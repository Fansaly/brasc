$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Write-Message.ps1"
. "${PSScriptsPath}\Confirm-YesOrNo.ps1"
. "${PSScriptsPath}\Get-DisplayInfo.ps1"
. "${ScriptFilePath}\SteamHelper.ps1"


$configFile = "${ScriptFilePath}\config.psd1"
$config = Import-PowerShellDataFile $configFile
$appPath = $config.AppPath
$steamServiceApp = "${appPath}\bin\steamservice.exe"

if (![IO.File]::Exists($steamServiceApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``SteamService.exe' application doesn't exist." -ForegroundColor Yellow
  exit
}


# install Steam Service
$service = Get-Service | Where-Object Name -Match 'Steam'
if (!$service) {
  Start-Process -FilePath $steamServiceApp -ArgumentList '/install' -WindowStyle Hidden -Wait
}


# setting Steam regedit
$regPath = $config.RegPath
$settings = $config.Settings

if (!(Test-Path -Path ($regPath | Split-Path))) {
  New-Item -Path ($regPath | Split-Path) | Out-Null
}

if (!(Test-Path -Path $regPath)) {
  New-Item -Path $regPath | Out-Null

  $settings.Keys | % {
    $name = $_
    $type = $settings.$name[0]
    $value = $settings.$name[1]

    Set-ItemProperty -Path $regPath -Type $type -Name $name -Value $value
  }
}


# setting Steam main window position
$dialogConfigFile = "$appPath\config\DialogConfig.vdf"
if (![IO.File]::Exists($dialogConfigFile)) { exit }

$DisplayInfo = Get-PrimaryDisplayInfo
$dialogConfig = ConvertFrom-VDF -InputObject (Get-Content $dialogConfigFile)
$steamRootDialog = $dialogConfig.UserConfigData.SteamRootDialog
$steamWindowTarget = $config.Window
$steamWindowCurrent = @{}

$steamWindowTarget += @{
  xpos = [int][Math]::Floor(($DisplayInfo.AvailWidth / $DisplayInfo.ScreenScalingFactor - $steamWindowTarget.wide) / 2)
  ypos = [int][Math]::Floor(($DisplayInfo.AvailHeight / $DisplayInfo.ScreenScalingFactor - $steamWindowTarget.tall) / 2)
}
$steamWindowTarget.Keys | % { $steamWindowCurrent.$_ = [int]$steamRootDialog.$_ }

$steamWindowTarget = New-Object -TypeName PSObject -Property $steamWindowTarget
$steamWindowCurrent = New-Object -TypeName PSObject -Property $steamWindowCurrent

$isDiff = [bool](Compare-Object $steamWindowTarget.PSObject.Properties $steamWindowCurrent.PSObject.Properties)

if (!$isDiff) { exit }

# detect running status of Steam application
$status = Get-Process | Where-Object ProcessName -Match 'Steam'

if ($status) {
  Write-Message "Please exit ``Steam' then configure."

  $choice = Confirm-YesOrNo
  if ($choice -eq 'n') {
    exit
  }
}

$steamWindowTarget | Get-Member -MemberType NoteProperty | Select-Object -Property Name | % {
  $key = $_.Name
  $value = [string]$steamWindowTarget.$key
  Add-Member -InputObject $dialogConfig.UserConfigData.SteamRootDialog -MemberType NoteProperty -Name $key -Value $value -Force
}

ConvertTo-VDF -InputObject $dialogConfig | Out-File $dialogConfigFile -Encoding UTF8 -NoNewline
