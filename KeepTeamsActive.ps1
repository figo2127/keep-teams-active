<#
Keep Teams Active (toggle)

  Install (once):  double-click Install.bat
                   (or: powershell -ExecutionPolicy Bypass -File .\KeepTeamsActive.ps1 -Install)
  Use:             Double-click "Keep Teams Active" on desktop  -> ON  (tray icon appears)
                   Double-click it again                         -> OFF
                   Or right-click tray icon > Stop
  Remove:          double-click Uninstall.bat
                   (or: powershell -ExecutionPolicy Bypass -File .\KeepTeamsActive.ps1 -Uninstall)

  How: sends an F15 keypress (no app uses it) every N seconds, which resets the
  Windows idle timer that Teams reads. Also blocks sleep / display-off while ON.
#>
param(
    [switch]$Install,
    [switch]$Uninstall,
    [int]$IntervalSec = 60
)

$AppName    = 'Keep Teams Active'
$InstallDir = Join-Path $env:LOCALAPPDATA 'KeepTeamsActive'
$Target     = Join-Path $InstallDir 'KeepTeamsActive.ps1'
$Lnk        = Join-Path ([Environment]::GetFolderPath('Desktop')) "$AppName.lnk"
$MutexName  = 'Local\KeepTeamsActive'
$StopName   = 'Local\KeepTeamsActive_Stop'

# ---------------- install / uninstall ----------------
if ($Install) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    if ($PSCommandPath -ne $Target) { Copy-Item $PSCommandPath $Target -Force }
    Unblock-File $Target -ErrorAction SilentlyContinue   # clear "downloaded from internet" flag

    $s = (New-Object -ComObject WScript.Shell).CreateShortcut($Lnk)
    $s.TargetPath       = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
    $s.Arguments        = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$Target`" -IntervalSec $IntervalSec"
    $s.WorkingDirectory = $InstallDir
    $s.WindowStyle      = 7   # minimized, avoids console flash
    $s.Description      = "Toggle $AppName on/off"
    $s.Save()
    Write-Host "Installed. Shortcut: $Lnk"
    return
}

if ($Uninstall) {
    try { [System.Threading.EventWaitHandle]::OpenExisting($StopName).Set() | Out-Null; Start-Sleep 2 } catch {}
    Remove-Item $Lnk -Force -ErrorAction SilentlyContinue
    Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host 'Uninstalled.'
    return
}

# ---------------- toggle: if already running, stop it ----------------
$created = $false
$mutex   = New-Object System.Threading.Mutex($true, $MutexName, [ref]$created)
$stopEvt = New-Object System.Threading.EventWaitHandle($false, [System.Threading.EventResetMode]::AutoReset, $StopName)

if (-not $created) {
    $stopEvt.Set() | Out-Null
    (New-Object -ComObject WScript.Shell).Popup("${AppName}: OFF", 2, $AppName, 64) | Out-Null
    return
}

# ---------------- run ----------------
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
Add-Type -Namespace KTA -Name Native -MemberDefinition @'
[DllImport("kernel32.dll")] public static extern uint SetThreadExecutionState(uint esFlags);
[DllImport("user32.dll")]   public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
'@

$ES_ON  = [uint32]2147483651   # ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED
$ES_OFF = [uint32]2147483648   # ES_CONTINUOUS (reset)

$Nudge = {
    [KTA.Native]::keybd_event(0x7E, 0, 0, [UIntPtr]::Zero)   # F15 down
    [KTA.Native]::keybd_event(0x7E, 0, 2, [UIntPtr]::Zero)   # F15 up
}

$tray = New-Object System.Windows.Forms.NotifyIcon
$tray.Icon    = [System.Drawing.SystemIcons]::Information
$tray.Text    = "${AppName}: ON (${IntervalSec}s)"
$menu = New-Object System.Windows.Forms.ContextMenuStrip
$menu.Items.Add('Stop', $null, { [System.Windows.Forms.Application]::Exit() }) | Out-Null
$tray.ContextMenuStrip = $menu
$tray.Visible = $true
$tray.ShowBalloonTip(2000, $AppName, 'ON. Double-click shortcut again or right-click tray icon to stop.', 'Info')

$nudgeTimer = New-Object System.Windows.Forms.Timer
$nudgeTimer.Interval = [Math]::Max(5, $IntervalSec) * 1000
$nudgeTimer.add_Tick($Nudge)

$watchTimer = New-Object System.Windows.Forms.Timer
$watchTimer.Interval = 1000
$watchTimer.add_Tick({ if ($stopEvt.WaitOne(0)) { [System.Windows.Forms.Application]::Exit() } })

try {
    [KTA.Native]::SetThreadExecutionState($ES_ON) | Out-Null
    & $Nudge
    $nudgeTimer.Start()
    $watchTimer.Start()
    [System.Windows.Forms.Application]::Run()
}
finally {
    $nudgeTimer.Stop(); $watchTimer.Stop()
    [KTA.Native]::SetThreadExecutionState($ES_OFF) | Out-Null
    $tray.Visible = $false
    $tray.Dispose()
    $mutex.ReleaseMutex(); $mutex.Dispose(); $stopEvt.Dispose()
}
