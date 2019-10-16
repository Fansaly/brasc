Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $ScriptFilePath | Split-Path -Leaf
$name = 'StartLayout'


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


Push-Location -Path $ScriptFilePath

$regFile = "${computerName}\${name}.reg"
$xmlFile = "${computerName}\DefaultLayouts.xml"

if ([IO.File]::Exists("${ScriptFilePath}\${regFile}")) {
  REG IMPORT $regFile 2>&1 | Out-Null
} else {
  Write-Message "``${regFile}' file doesn't exist."
}

if ([IO.File]::Exists("${ScriptFilePath}\${xmlFile}")) {
  Copy-Item -Path $xmlFile -Destination "$HOME\AppData\Local\Microsoft\Windows\Shell\"
} else {
  Write-Message "``${xmlFile}' file doesn't exist."
}

Pop-Location

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
