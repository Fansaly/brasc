@echo off
rem mode con cols=80 lines=23
rem color 5B
title Config Windows and Apps

cd /d %~dp0
set masterDir=%~dp0
if "%masterDir:~-1%" == "\" set masterDir=%masterDir:~0,-1%

set argument=%~1
set windowsDir=%masterDir%\Windows

if /i "%argument%" == "-b" set backup=1
if /i "%argument%" == "/b" set backup=1
if /i "%argument%" == "-r" set restore=1
if /i "%argument%" == "/r" set restore=1
if /i "%argument%" == "-d" set download=1
if /i "%argument%" == "/d" set download=1

if defined backup (
  powershell -ExecutionPolicy RemoteSigned -File "%windowsDir%\_backup.ps1"
) else if defined restore (
  call :PERMISSION
  powershell -ExecutionPolicy RemoteSigned -File "%windowsDir%\_restore.ps1"
) else if defined download (
  powershell -ExecutionPolicy RemoteSigned -File "%windowsDir%\_download.ps1"
) else (
  call :USAGE
  exit
)

echo.
echo.
echo [7m all done. [0m
echo.
exit


:USAGE
echo   %~nx0 [-b ^| -r ^| -d]
echo.
echo   -b    Backup current Windows and Apps configuration.
echo.
echo   -r    Restore Windows and Apps configuration to current.
echo         Requires administrator privileges.
echo.
echo   -d    Download some applications from internet.
echo.
goto :EOF


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