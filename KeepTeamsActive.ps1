<#
Keep Teams Active (toggle)

  Run:   powershell -NoProfile -ExecutionPolicy Bypass -File .\KeepTeamsActive.ps1
         -> ON (tray icon appears near the clock)
  Stop:  right-click the tray icon > Stop, close the PowerShell window,
         or run the same command again (it toggles OFF).
  Option: -IntervalSec 120   (seconds between key presses, default 60)

  Nothing is installed: no shortcuts, no registry, no files written.

  How: sends an F15 keypress (no app uses it) every N seconds, which resets the
  Windows idle timer that Teams reads. Also blocks sleep / display-off while ON.
#>
param(
    [int]$IntervalSec = 60
)

$AppName    = 'Keep Teams Active'
$MutexName  = 'Local\KeepTeamsActive'
$StopName   = 'Local\KeepTeamsActive_Stop'

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
$tray.ShowBalloonTip(2000, $AppName, 'ON. Right-click this tray icon > Stop to turn off.', 'Info')

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
