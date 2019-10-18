$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Set-StartupItem.ps1"


$ssApp = 'D:\Program Files\Shadowsocks\Shadowsocks.exe'

if (![IO.File]::Exists($ssApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Shadowsocks.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}


Set-StartupItem -Action 'Create' -Path 'HKCU' -Name 'Shadowsocks' -Value $ssApp

$isRunning = Get-Process | Where-Object ProcessName -Match 'Shadowsocks'

if (!$isRunning) {
  Start-Process -FilePath $ssApp
}
