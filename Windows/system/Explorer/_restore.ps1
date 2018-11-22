Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


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
. "${PSScriptsPath}\Get-ScreenInfo.ps1"
. "${PSScriptsPath}\Get-UIPlacement.ps1"


$configFile = "${currentPath}\config.psd1"

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

  $ScreenInfo = Get-ScreenInfo -IsPrimary
  $UIPlacement = Get-UIPlacement -ScreenInfo $ScreenInfo -UISizes $UI.Sizes
  $Pos = "Pos$($ScreenInfo.Resolution)x96(1)"

  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.bottom" -Value $UIPlacement.Bottom
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.left"   -Value $UIPlacement.Left
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.right"  -Value $UIPlacement.Right
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Win${Pos}.top"    -Value $UIPlacement.Top

  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Max${Pos}.x" -Value $([Convert]::ToString('0xffffffff', 10))
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Max${Pos}.y" -Value $([Convert]::ToString('0xffffffff', 10))
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Min${Pos}.x" -Value $([Convert]::ToString('0xffff8300', 10))
  Set-ItemProperty -Path $UI.RegPath -Type 'DWord' -Name "Min${Pos}.y" -Value $([Convert]::ToString('0xffff8300', 10))
}


function Set-ExplorerSetting {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Path = '',
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [object]
    $Data
  )

  if ($Data -isnot [hashtable] -and $Data -isnot [array]) { return }

  if ($Data -is [array]) {
    $Type  = $Data[0]
    $Value = $Data[1]
    $Name  = $Path | Split-Path -Leaf
    $Path  = $Path | Split-Path

    if (!(Test-Path -Path $Path)) {
      New-Item -Path $Path | Out-Null
    }

    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
  } else {
    $Data.Keys | ForEach-Object {
      Set-ExplorerSetting -Data $Data.$_ -Path "$Path\$_"
    }
  }
}

# https://www.tenforums.com/tutorials/101852-enable-disable-timeline-windows-10-a.html
# https://www.tenforums.com/tutorials/110063-enable-disable-sync-activities-pc-cloud-windows-10-a.html

# setting Explorer
Set-ExplorerPlacement -UI $config.UI
Set-ExplorerSetting -Path $config.RegPath -Data $config.Settings

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
