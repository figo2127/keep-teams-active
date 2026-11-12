@echo off
title Keep Teams Active - Install
echo.
echo Installing Keep Teams Active...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0KeepTeamsActive.ps1" -Install
if errorlevel 1 (
  echo.
  echo Something went wrong. See the Troubleshooting section in README.md.
) else (
  echo.
  echo Done! A "Keep Teams Active" icon is now on your desktop.
  echo Double-click it to turn ON. Double-click it again to turn OFF.
)
echo.
pause
