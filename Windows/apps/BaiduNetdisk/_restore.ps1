$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$hasAdmPermissions = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$hasAdmPermissions) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please run as Administrator." -ForegroundColor Yellow
  exit
}


# remove Upload to Baidu Netdisk from ContextMenu
# Registry::HKEY_CLASSES_ROOT => HKLM:\Software\Classes
Remove-Item -LiteralPath 'Registry::HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\YunShellExt'
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\YunShellExt' 2>&1 | Out-Null

# FriendlyAppName
$friendlyPath = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache'
Get-Item -Path $friendlyPath `
| Select-Object -ExpandProperty Property `
| % {
  if ($_ -match 'BaiduNetdisk') {
    Set-ItemProperty -Path $friendlyPath -Name $_ -Value 'BaiduNetdisk'
  }
}

# remove Baidu App or Service from Startup
$startupPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
Get-Item -Path $startupPath `
| Select-Object -ExpandProperty Property `
| % {
  if ($_ -match 'Baidu') {
    Remove-ItemProperty -Path $startupPath -Name $_
  }
}
