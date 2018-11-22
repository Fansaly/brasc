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
. "${PSScriptsPath}\Write-Message.ps1"
. "${PSScriptsPath}\Confirm-YesOrNo.ps1"
. "${PSScriptsPath}\Get-ScreenInfo.ps1"
. "${PSScriptsPath}\Get-UIPlacement.ps1"


$configFile = "${currentPath}\config.psd1"

if (![IO.File]::Exists($configFile)) {
  Write-Message "``7-Zip' config file doesn't exist."
  exit
}

$global:config = Import-PowerShellDataFile $configFile

if (!(Test-Path -Path $config.RegPath)) {
  Write-Message "Not yet installed ``7-Zip'."
  exit
}

# detect running status of 7zFM application
$status = Get-Process | Where-Object ProcessName -Match '7zFM'

if ($status) {
  Write-Message "Please exit ``7zFM' then configure."

  $choice = Confirm-YesOrNo
  if ($choice -eq 'n') {
    exit
  }
}


function Set-7zFMPlacement {
  $screenInfo  = Get-ScreenInfo -IsPrimary
  $UIPlacement = Get-UIPlacement -ScreenInfo $screenInfo -UISizes $config.UI.Sizes

  $PlacementLeft   = $UIPlacement.Left
  $PlacementRight  = $UIPlacement.Right
  $PlacementTop    = $UIPlacement.Top
  $PlacementBottom = $UIPlacement.Bottom

  # 7zFM window position
  # order must be as follows:
  # left, top, right, bottom
  $Placement = @()
  $Placement += @(($PlacementLeft   % 255), ([Math]::Floor($PlacementLeft   / 255)), 0, 0)
  $Placement += @(($PlacementTop    % 255), ([Math]::Floor($PlacementTop    / 255)), 0, 0)
  $Placement += @(($PlacementRight  % 255), ([Math]::Floor($PlacementRight  / 255)), 0, 0)
  $Placement += @(($PlacementBottom % 255), ([Math]::Floor($PlacementBottom / 255)), 0, 0)
  $Placement += @(0, 0, 0, 0)

  Set-ItemProperty -Path $config.UI.RegPath -Name 'Position' -Type 'Binary' -Value $Placement
}

function Set-7zSetting {
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

    if ($Value -is [array]) {
      $Value = $Value | % -Begin { $sum = 0 } -Process { $sum += $_ } -End { $sum; Remove-Variable sum }
    }

    if (!(Test-Path -Path $Path)) {
      New-Item -Path $Path | Out-Null
    }

    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
  } else {
    $Data.Keys | ForEach-Object {
      Set-7zSetting -Data $Data.$_ -Path "$Path\$_"
    }
  }
}

Set-7zFMPlacement
Set-7zSetting -Path $config.RegPath -Data $config.Settings
