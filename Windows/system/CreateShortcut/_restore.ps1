# set current path and scripts lib path
if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$PSScriptsPath = (Get-Item -Path $currentPath).Parent.Parent.FullName + '\.PSScripts'

if (!(Test-Path -Path $PSScriptsPath)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "PSScripts path doesn't exist." -ForegroundColor Yellow
  exit
}


# set PowerShell execution policy and source script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
. "${PSScriptsPath}\New-Shortcut.ps1"


$Location = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

New-Shortcut -Path 'C:\Program Files\Realtek\Audio\HDA\RtkNGUI64.exe' -Location $Location -Name 'Realtek 高清晰音频管理器'
New-Shortcut -Path 'D:\Program Files\Notepad++\notepad++.exe'         -Location $Location -Name 'Notepad++'
New-Shortcut -Path 'D:\Program Files\Beyond Compare\BCompare.exe'     -Location $Location -Name 'Beyond Compare'
New-Shortcut -Path 'D:\Program Files\Tencent\WeChat\WeChat.exe'       -Location $Location -Name '微信'
New-Shortcut -Path 'D:\Program Files\Thunder\Program\Thunder.exe'     -Location $Location -Name '迅雷'
New-Shortcut -Path 'D:\Program Files\Steam\Steam.exe'                 -Location $Location -Name 'Steam'
New-Shortcut -Path 'D:\Program Files\Blizzard\Battle.net\Battle.net Launcher.exe' -Location $Location -Name '暴雪战网'
