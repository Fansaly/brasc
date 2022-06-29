$ScriptFilePath = $PSScriptRoot
$configFileName = "settings.json"

$ConfigPath = "$env:APPDATA\Code\User"
$ConfigFile = "${ConfigPath}\${configFileName}"


$code = 'code'
Get-Command -Name $code -ErrorAction Ignore | Out-Null

if (!$?) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Visual Studio Code' isn't installed." -ForegroundColor Yellow
  exit
} elseif (!(Test-Path -Path "$ConfigPath") -or ![IO.File]::Exists("$ConfigFile")) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Visual Studio Code ``${configFileName}' file doesn't exist." -ForegroundColor Yellow
  exit
}


Copy-Item -Path "$ConfigFile" -Destination "${ScriptFilePath}\"
