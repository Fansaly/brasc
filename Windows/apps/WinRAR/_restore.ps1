$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Write-Message.ps1"
. "${PSScriptsPath}\Confirm-YesOrNo.ps1"
. "${PSScriptsPath}\Get-DisplayInfo.ps1"
. "${PSScriptsPath}\Get-UIPlacement.ps1"
. "${PSScriptsPath}\Set-Registry.ps1"
. "${PSScriptsPath}\Merge-Object.ps1"
. "${ScriptFilePath}\Get-Size.ps1"


$global:DisplayInfo = Get-PrimaryDisplayInfo

$ConfigCommonFile  = "${ScriptFilePath}\config.common.psd1"
$ConfigSizeFile = "${ScriptFilePath}\config.$($DisplayInfo.Resolution).psd1"

$ConfigCommon = Import-PowerShellDataFile $ConfigCommonFile

if ([IO.File]::Exists($ConfigSizeFile)) {
  $ConfigSize = Import-PowerShellDataFile $ConfigSizeFile
} else {
  $ConfigSize = Get-Size -DisplayInfo $DisplayInfo
}

$global:config = Merge-Object $ConfigCommon $ConfigSize

if (!(Test-Path -Path $config.RegPath)) {
  Write-Message "Not yet installed ``WinRAR'."
  exit
}

# detect running status of WinRAR application
$status = Get-Process | Where-Object ProcessName -Match 'WinRAR'

if ($status) {
  Write-Message "Please exit ``WinRAR' then configure."

  $choice = Confirm-YesOrNo
  if ($choice -eq 'n') {
    exit
  }
}


function Get-MainWindowPlacement {
  $UIPlacement = Get-UIPlacement -DisplayInfo $DisplayInfo -UISizes $config.Sizes

  $PlacementLeft   = $UIPlacement.Left
  $PlacementRight  = $UIPlacement.Right
  $PlacementTop    = $UIPlacement.Top
  $PlacementBottom = $UIPlacement.Bottom

  # WinRAR window position
  # order must be as follows:
  # left, top, right, bottom
  $Placement = @()
  $Placement += @(($PlacementLeft   % 255), ([Math]::Floor($PlacementLeft   / 255)), 0, 0)
  $Placement += @(($PlacementTop    % 255), ([Math]::Floor($PlacementTop    / 255)), 0, 0)
  $Placement += @(($PlacementRight  % 255), ([Math]::Floor($PlacementRight  / 255)), 0, 0)
  $Placement += @(($PlacementBottom % 255), ([Math]::Floor($PlacementBottom / 255)), 0, 0)

  return $Placement
}


# setting WinRAR
Set-Registry -Path $config.RegPath -Data $config.Settings -CallBack {
  Param ([object]$Data)

  $Value = $Data[1]

  if ($Data.Count -gt 2) {
    $Method = $Data[2]
    $Value += Get-MainWindowPlacement
  }

  return $Value
}
