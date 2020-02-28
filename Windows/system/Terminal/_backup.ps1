$ScriptFilePath = $PSScriptRoot
$configFileName = "profiles.json"

$TerminalPath = (Resolve-Path -Path "${env:LocalAppData}\Packages\Microsoft.WindowsTerminal_*").Path
$TerminalConfigPath = "${TerminalPath}\LocalState"
$TerminalConfigFile = "${TerminalConfigPath}\${configFileName}"


if ([String]::IsNullOrEmpty($TerminalPath)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Terminal' isn't installed." -ForegroundColor Yellow
  exit
} elseif (!(Test-Path -Path "$TerminalConfigPath") -or ![IO.File]::Exists("$TerminalConfigFile")) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Terminal ``${configFileName}' file doesn't exist." -ForegroundColor Yellow
  exit
}


Copy-Item -Path "$TerminalConfigFile" -Destination "${ScriptFilePath}\"
