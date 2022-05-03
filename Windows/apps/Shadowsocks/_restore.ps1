$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Set-StartupItem.ps1"


$installPaths = @(
  "$env:LocalAppdata\Applications\Shadowsocks",
  'D:\Applications\Shadowsocks'
)

$installPaths | % {
  if ([IO.File]::Exists("$_\Shadowsocks.exe")) {
    $ssApp = "$_\Shadowsocks.exe"
    return
  }
}

if (![IO.File]::Exists($ssApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Shadowsocks.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}


$isRunning = Get-Process | Where-Object ProcessName -Match 'Shadowsocks'

if (!$isRunning) {
  Start-Process -FilePath $ssApp
}
