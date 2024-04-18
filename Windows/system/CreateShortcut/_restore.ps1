$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\New-Shortcut.ps1"


$configFile = "${ScriptFilePath}\config.psd1"

if (![IO.File]::Exists($configFile)) { exit }


$config = Import-PowerShellDataFile $configFile
$LinkLocation = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

$config.Programs | % {
  $Path = $_.Path
  $Name = $_.Name
  $Location = $_.Location
  $Arguments = $_.Arguments

  if ([String]::IsNullOrEmpty($Location) -or !(Test-Path -Path $Location)) {
    $Location = $LinkLocation
  }

  $Path | % {
    if ([IO.File]::Exists([Environment]::ExpandEnvironmentVariables($_))) {
      New-Shortcut -Path $_ -Location $Location -Name $Name -Arguments $Arguments
      return
    }
  }
}
