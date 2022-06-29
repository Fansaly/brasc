Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Get-DisplayInfo.ps1"
. "${PSScriptsPath}\Get-UIPlacement.ps1"
. "${PSScriptsPath}\Set-Registry.ps1"


$configFile = "${ScriptFilePath}\config.psd1"

if (![IO.File]::Exists($configFile)) {
  Write-Message "``Windows Explorer' config file doesn't exist."
  exit
}

$config = Import-PowerShellDataFile $configFile


function Set-ExplorerPlacement {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [hashtable]
    $UI
  )

  $DisplayInfo = Get-PrimaryDisplayInfo
  $UIPlacement = Get-UIPlacement -DisplayInfo $DisplayInfo -UISizes $UI.Sizes
  $Pos = "Pos$($DisplayInfo.Resolution)x$($DisplayInfo.PixelsPerInch)(1)"

  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.bottom" -Value $UIPlacement.Bottom
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.left"   -Value $UIPlacement.Left
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.right"  -Value $UIPlacement.Right
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.top"    -Value $UIPlacement.Top

  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Max${Pos}.x" -Value $([Convert]::ToString('0xffffffff', 10))
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Max${Pos}.y" -Value $([Convert]::ToString('0xffffffff', 10))
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Min${Pos}.x" -Value $([Convert]::ToString('0xffff8300', 10))
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Min${Pos}.y" -Value $([Convert]::ToString('0xffff8300', 10))
}


# setting Explorer
Set-ExplorerPlacement -UI $config.UI
Set-Registry -Path $config.RegPath -Data $config.Settings

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
