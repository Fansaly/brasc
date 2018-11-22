Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $Silent = $False
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
. "${PSScriptsPath}\Write-Message.ps1"
. "${PSScriptsPath}\Confirm-YesOrNo.ps1"


function round($value, [MidpointRounding]$mode = 'AwayFromZero') {
  return [Math]::Round($value, $mode)
}

function DecToHex($data) {
  $result = [Convert]::ToString($data, 16)
  $result = $result.PadLeft(4, '0')
  return $result
}

function HexToDec($data) {
  return [Convert]::ToString("0x${data}", 10)
}


$configFile = "${currentPath}\config.psd1"

if (![IO.File]::Exists($configFile)) {
  Write-Message "``Command Prompt and PowerShell' config file doesn't exist."
  exit
}

$config = Import-PowerShellDataFile $configFile

# setting Command Prompt and PowerShell
$consolePath = $config.RegPath
$console = $config.Console

$FaceName = $console.FaceName

$FontSize = DecToHex($console.FontSize)
$FontSize = HexToDec("${FontSize}0000")

$WindowSize = $console.WindowSize
$WindowSize = HexToDec($(DecToHex($WindowSize.height)) + $(DecToHex($WindowSize.width)))

$WindowAlpha = $console.WindowAlpha
$WindowAlpha = round($WindowAlpha / 100 * 255)

Set-ItemProperty -Path $consolePath -Name 'FaceName' -Type String -Value $FaceName
Set-ItemProperty -Path $consolePath -Name 'FontSize' -Type DWord -Value $FontSize
Set-ItemProperty -Path $consolePath -Name 'WindowSize' -Type DWord -Value $WindowSize
Set-ItemProperty -Path $consolePath -Name 'WindowAlpha' -Type DWord -Value $WindowAlpha

# remove private settings of Command Prompt
Get-ChildItem -Path $consolePath | ForEach-Object {
  $keyName = $_.Name | Split-Path -Leaf

  if (!($keyName -match 'PowerShell')) {
    Remove-Item -Path "${consolePath}\${keyName}"
  }
}

# detect running status of PowerShell ISE application
$status = Get-Process | Where-Object ProcessName -Match 'powershell_ise'

if ($status) {
  Write-Message "Please exit ``Windows PowerShell ISE' then configure."

  $choice = Confirm-YesOrNo
  if ($choice -eq 'n') {
    exit
  }
}

# setting PowerShell ISE
$configFileName = 'user.config'
$configRootPath = "${env:LocalAppData}\Microsoft_Corporation"

if (Test-Path -Path $configRootPath) {
  $configPath = (Resolve-Path -Path "${configRootPath}\powershell_ise*\3.0.0.0").Path

  if (![String]::IsNullOrEmpty($configPath)) {
    $configFilePSISE = Join-Path -Path $configPath -ChildPath $configFileName
  }
}

if (![IO.File]::Exists($configFilePSISE)) {
  if (!$Silent) {
    Write-Message "``Windows PowerShell ISE' config file doesn't exist."
  }

  exit
}

$psiseConfig = $config.PowerShellISE
# more information and documentation found here:
# http://www.powertheshell.com/iseconfig
$psiseConfig.Keys | ForEach-Object -Begin {
  [xml]$xml = Get-Content -Path $configFilePSISE -Raw

  # find all settings available with their correct casing:
  $settings = $xml.SelectNodes('//setting') | Where-Object serializeAs -EQ String | Select-Object -ExpandProperty Name
} -Process {
  # translate the user-submitted setting into the correct casing:
  $name = $settings -like $_
  $value = $psiseConfig.Item($_)

  if (!$name) {
    $name = $_

    $nodeValue = $xml.CreateElement('value')
    $nodeSetting = $xml.CreateElement('setting')

    $attrName = $nodeSetting.OwnerDocument.CreateAttribute('name')
    $attrSeri = $nodeSetting.OwnerDocument.CreateAttribute('serializeAs')
    $attrName.Value = $name
    $attrSeri.Value = 'String'

    $nodeSetting.Attributes.Append($attrName) | Out-Null
    $nodeSetting.Attributes.Append($attrSeri) | Out-Null

    $nodeSetting.AppendChild($nodeValue) | Out-Null
    $xml.configuration.userSettings.UserSettings.AppendChild($nodeSetting) | Out-Null
  }

  $xml.SelectNodes(('//setting[@name="{0}"]' -f $name))[0].Value = [string]$value
} -End {
  $xml.Save($configFilePSISE)
}
