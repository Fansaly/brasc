$ScriptFilePath = $PSScriptRoot

. "${ScriptFilePath}\Get-Config.ps1"


$config = Get-Config

if ($config.Count -eq 0) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Clash for Windows.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}

$isRunning = Get-Process | Where-Object ProcessName -Match $config.name

if (!$isRunning) {
  Start-Process -FilePath $config.app
}
