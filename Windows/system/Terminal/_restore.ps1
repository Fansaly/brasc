$ScriptFilePath = $PSScriptRoot
$configFileName = "settings.json"

$TerminalPath = (Resolve-Path -Path "${env:LocalAppData}\Packages\Microsoft.WindowsTerminal_*").Path
$TerminalConfigPath = "${TerminalPath}\LocalState"


if ([String]::IsNullOrEmpty($TerminalPath)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Terminal' isn't installed." -ForegroundColor Yellow
  exit
}


if (!(Test-Path -Path "$TerminalConfigPath")) {
  New-Item -Path $TerminalConfigPath -ItemType Directory | Out-Null
}

Copy-Item -Path "${ScriptFilePath}\${configFileName}" -Destination "${TerminalConfigPath}\"
