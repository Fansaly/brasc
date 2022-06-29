Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Set-Registry.ps1"


$configFile = "${ScriptFilePath}\config.psd1"

if (![IO.File]::Exists($configFile)) {
  Write-Message "``Taskbar' config file doesn't exist."
  exit
}

$config = Import-PowerShellDataFile $configFile


Set-Registry -Path $config.RegPath -Data $config.Settings

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
