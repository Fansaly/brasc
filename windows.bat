@echo off
rem mode con cols=80 lines=23
rem color 5B
title Config Windows and Apps

cd /d %~dp0
set masterDir=%~dp0
if "%masterDir:~-1%" == "\" set masterDir=%masterDir:~0,-1%

set windowsDir=%masterDir%\Windows

set argument=%~1

if /i "%argument%" == "/b" (
  call :PERMISSION
  powershell -ExecutionPolicy RemoteSigned -File "%windowsDir%\_backup.ps1"
) else if /i "%argument%" == "/r" (
  call :PERMISSION
  powershell -ExecutionPolicy RemoteSigned -File "%windowsDir%\_restore.ps1"
) else if /i "%argument%" == "/d" (
  powershell -ExecutionPolicy RemoteSigned -File "%windowsDir%\_download.ps1"
) else (
  echo   %~nx0 [/b ^| /r ^| /d]
  echo.
  echo   /b    Backup current Windows and Apps configuration.
  echo.
  echo   /r    Restore Windows and Apps configuration to current.
  echo         Requires administrator privileges.
  echo.
  echo   /d    Download some applications from internet.
  echo.
  exit
)

echo.
echo.
echo [7m all done. [0m
echo.
exit


:PERMISSION
if exist "%SystemRoot%\System32\whoami.exe" (
  whoami /GROUPS | find /i "S-1-16-12288" >nul || set PowerDenied=1
) else (
  md %SystemRoot%\System32\#Permission# >nul 2>nul
  if not exist "%SystemRoot%\System32\#Permission#" set PowerDenied=1
  del /f /q "%SystemRoot%\System32\#Permission#" >nul 2>nul
)
if defined PowerDenied (
  echo [45m Please run as Administrator. [0m
  echo.
  exit
)
goto :EOF