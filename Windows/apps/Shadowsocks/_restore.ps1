$ssApp = 'D:\Program Files\Shadowsocks\Shadowsocks.exe'

if (![IO.File]::Exists($ssApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Shadowsocks.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}


$startupPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'

$isAutoRun = Get-Item -Path $startupPath `
| Select-Object -ExpandProperty Property `
| ? { (Get-ItemPropertyValue -Path $startupPath -Name $_) -eq $ssApp }

if (!$isAutoRun) {
  Set-ItemProperty -Path $startupPath -Type 'String' -Name 'Shadowsocks' -Value $ssApp
}

$isRunning = Get-Process | Where-Object ProcessName -Match 'Shadowsocks'

if (!$isRunning) {
  Start-Process -FilePath $ssApp
}
