if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$PSScriptsPath = (Get-Item -Path $currentPath).Parent.Parent.FullName + '\.PSScripts'

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $currentPath | Split-Path -Leaf
$name = 'TaskManager'

if ($folderName -ne $name) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${name}' isn't name of current directory." -ForegroundColor Yellow
  exit
} elseif (!(Test-Path -Path "${currentPath}\${computerName}")) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "No data of ``${computerName}' computer." -ForegroundColor Yellow
  exit
} elseif (!(Test-Path -Path $PSScriptsPath)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "PSScripts path doesn't exist." -ForegroundColor Yellow
  exit
}


# set PowerShell execution policy and source script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
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

Push-Location -Path $currentPath

$regFile = "${computerName}\${name}.reg"

if ([IO.File]::Exists("${currentPath}\${regFile}")) {
  REG IMPORT $regFile 2>&1 | Out-Null
} else {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${regFile}' file doesn't exist." -ForegroundColor Yellow
}

Pop-Location
