$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $ScriptFilePath | Split-Path -Leaf
$name = 'TaskManager'


if ($folderName -ne $name) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${name}' isn't name of current directory." -ForegroundColor Yellow
  exit
} elseif (!(Test-Path -Path "${ScriptFilePath}\${computerName}")) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "No data of ``${computerName}' computer." -ForegroundColor Yellow
  exit
}


. "${PSScriptsPath}\Write-Message.ps1"
. "${PSScriptsPath}\Confirm-YesOrNo.ps1"


# detect running status of TaskManager application
$status = Get-Process | Where-Object ProcessName -Match 'Taskmgr'

if ($status) {
  Write-Message "Please exit ``TaskManager' then configure."

  $choice = Confirm-YesOrNo
  if ($choice -eq 'n') {
    exit
  }
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
