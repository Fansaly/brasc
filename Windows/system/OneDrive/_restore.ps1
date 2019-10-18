$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Set-StartupItem.ps1"


Get-Process | ? Name -Match 'OneDrive' | Stop-Process

Set-StartupItem -Action 'Remove' -Path 'HKCU' -Name 'OneDrive'
