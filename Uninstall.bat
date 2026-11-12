@echo off
title Keep Teams Active - Uninstall
echo.
echo Removing Keep Teams Active...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0KeepTeamsActive.ps1" -Uninstall
echo.
echo Done. The desktop icon has been removed.
echo You can now delete this folder too.
echo.
pause
