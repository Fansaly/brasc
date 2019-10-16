$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Disable-ScheduledTaskItem.ps1"
. "${PSScriptsPath}\Disable-StartupItem.ps1"


Disable-ScheduledTaskItem -TaskPath '\ASUS\' -TaskName 'Ez Update'
Disable-StartupItem -Path 'HKLM' -Name 'Sonic Studio'
