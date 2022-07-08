$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Get-PermissionStatus.ps1"

if (!$(Get-PermissionStatus)) { exit }


# Enable Microsoft-Windows-Subsystem-Linux
$result = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux'
if ($result.State -ne 'Enabled') {
  Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -NoRestart -WarningAction SilentlyContinue | Out-Null
  $restart = $True
}

# set default version
$lxssPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss'
$defaultVersion = 1

if (!(Test-Path -Path "$lxssPath")) {
  New-Item -Path "$lxssPath" | Out-Null
}

Get-ItemProperty -Path $lxssPath -Name 'DefaultVersion' -ErrorAction Ignore | Out-Null
if ($?) {
  $currentVersion = Get-ItemPropertyValue -Path $lxssPath -Name 'DefaultVersion' | Out-Null
}

if ($currentVersion -ne $defaultVersion) {
  Set-ItemProperty -Path "$lxssPath" -Name 'DefaultVersion' -Type 'DWord' -Value $defaultVersion
}

if ($defaultVersion -eq 2) {
  # Enable Microsoft-Hyper-V
  $result = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Hyper-V'
  if ($result.State -ne 'Enabled') {
    Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Hyper-V' -All -NoRestart -WarningAction SilentlyContinue | Out-Null
    $restart = $True
  }

  # wsl --update
}

if ($restart) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please restart computer." -ForegroundColor Yellow
}
