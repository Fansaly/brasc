$ScriptFilePath = $PSScriptRoot

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $ScriptFilePath | Split-Path -Leaf
$name = 'Notifications_Action_Center'

if ($folderName -ne $name) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${name}' isn't name of current directory." -ForegroundColor Yellow
  exit
}


Push-Location -Path $ScriptFilePath

if (!(Test-Path -Path $computerName)) {
  New-Item -Path $computerName -ItemType Directory | Out-Null
}

$regPath = "HKCU\Control Panel\Quick Actions\Pinned"
$regFile = "${computerName}\${name}.reg"

REG EXPORT $regPath $regFile /y | Out-Null

Pop-Location
