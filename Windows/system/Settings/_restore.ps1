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
  Write-Message "``Settings' config file doesn't exist."
  exit
}

$config = Import-PowerShellDataFile $configFile


$config.Items | % {
  Set-Registry -Path $_.RegPath -Data $_.Settings
}

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
