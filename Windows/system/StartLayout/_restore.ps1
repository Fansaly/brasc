Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


# set current path, scripts lib path, etc
if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$PSScriptsPath = (Get-Item -Path $currentPath).Parent.Parent.FullName + '\.PSScripts'

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $currentPath | Split-Path -Leaf
$name = 'StartLayout'

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


Push-Location -Path $currentPath

$regFile = "${computerName}\${name}.reg"
$xmlFile = "${computerName}\DefaultLayouts.xml"

if ([IO.File]::Exists("${currentPath}\${regFile}")) {
  REG IMPORT $regFile 2>&1 | Out-Null
} else {
  Write-Message "``${regFile}' file doesn't exist."
}

if ([IO.File]::Exists("${currentPath}\${xmlFile}")) {
  Copy-Item -Path $xmlFile -Destination "$HOME\AppData\Local\Microsoft\Windows\Shell\"
} else {
  Write-Message "``${xmlFile}' file doesn't exist."
}

Pop-Location

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
