$ScriptFilePath = $PSScriptRoot

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $ScriptFilePath | Split-Path -Leaf
$name = 'Notifications_Action_Center'

if ($folderName -ne $name) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${name}' isn't name of current directory." -ForegroundColor Yellow
  exit
} elseif (!(Test-Path -Path "${ScriptFilePath}\${computerName}")) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "No data of ``${computerName}' computer." -ForegroundColor Yellow
  exit
}


Push-Location -Path $ScriptFilePath

$regFile = "${computerName}\${name}.reg"

if ([IO.File]::Exists("${ScriptFilePath}\${regFile}")) {
  REG IMPORT $regFile 2>&1 | Out-Null
} else {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${regFile}' file doesn't exist." -ForegroundColor Yellow
}

Pop-Location
