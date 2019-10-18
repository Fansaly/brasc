$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Disable-ScheduledTaskItem.ps1"
. "${PSScriptsPath}\Set-StartupItem.ps1"


Disable-ScheduledTaskItem -TaskPath '\ASUS\' -TaskName 'Ez Update'
Set-StartupItem -Action 'Disable' -Path 'HKLM' -Name 'Sonic Studio'
