$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Get-PermissionStatus.ps1"

if (!$(Get-PermissionStatus)) { exit }


# Enable Microsoft-Windows-Subsystem-Linux
$result = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux'
if ($result.State -ne 'Enabled') {
  Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -NoRestart -WarningAction SilentlyContinue | Out-Null
  $restart = $True
}

# Enable Microsoft-Hyper-V
$result = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Hyper-V'
if ($result.State -ne 'Enabled') {
  Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Hyper-V' -All -NoRestart -WarningAction SilentlyContinue | Out-Null
  $restart = $True
}

if ($restart) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please restart computer." -ForegroundColor Yellow
}
