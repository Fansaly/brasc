$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$hasAdmPermissions = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$hasAdmPermissions) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please run as Administrator." -ForegroundColor Yellow
  exit
}


# Enabled Microsoft-Windows-Subsystem-Linux
$result = Get-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux'

if ($result.State -ne 'Enabled') {
  Enable-WindowsOptionalFeature -Online -FeatureName 'Microsoft-Windows-Subsystem-Linux' -NoRestart -WarningAction SilentlyContinue | Out-Null

  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please restart computer." -ForegroundColor Yellow
  exit
}
