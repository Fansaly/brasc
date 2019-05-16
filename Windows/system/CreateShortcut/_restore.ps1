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


$configFile = "${currentPath}\config.psd1"

if (![IO.File]::Exists($configFile)) { exit }


$config = Import-PowerShellDataFile $configFile
$LinkLocation = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

$config.Programs | % {
  $Path = $_.Path
  $Name = $_.Name
  $Location = $_.Location

  if ([String]::IsNullOrEmpty($Location) -or !(Test-Path -Path $Location)) {
    $Location = $LinkLocation
  }

  New-Shortcut -Path $Path -Location $Location -Name $Name
}
