$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Get-PermissionStatus.ps1"
. "${PSScriptsPath}\Invoke-PinToTaskbar.ps1"
. "${ScriptFilePath}\Get-Config.ps1"


if (!$(Get-PermissionStatus)) { exit }

$config = Get-Config

if ($config.Count -eq 0) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``sublime_text.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}

$installPath = $config.installPath
$sublimeApp = $config.sublimeApp
$configPath = $config.configPath
# pin Sublime Text to taskbar
Invoke-PinToTaskbar $sublimeApp

# add 'Open with Sublime Text' to Context Menu
# Registry::HKEY_CLASSES_ROOT => HKLM:\Software\Classes
$sublimeRegPath = 'Registry::HKEY_CLASSES_ROOT\*\shell\Open with Sublime Text'

New-Item -Path "$sublimeRegPath\command" -Force | Out-Null
Set-ItemProperty -LiteralPath $sublimeRegPath -Type 'String' -Name '(Default)' -Value 'Open with Sublime Text'
Set-ItemProperty -LiteralPath $sublimeRegPath -Type 'String' -Name 'Icon'      -Value $sublimeApp
Set-ItemProperty -LiteralPath "$sublimeRegPath\command" -Type 'String' -Name '(Default)' -Value "$sublimeApp `"%1`""

# Preferences, Key Bindings, Settings, etc
Copy-Item -Path "$configPath\*" -Destination "$installPath\" -Recurse -Force

# Package Control
$packageControlFile = $config.packageControlFile
$installedPackagesPath = $config.installedPackagesPath

if ([IO.File]::Exists("$installedPackagesPath/$packageControlFile")) { exit }

$packageControlUrl = $config.packageControlUrl
$proxyServer = $config.proxyServer

curl.exe -x $proxyServer -kfsIL "$packageControlUrl" | Out-Null

if (!$?) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Failed connect to Package Control server." -ForegroundColor Red
} else {
  $tmpFile = "$env:TMP\$packageControlFile"

  curl.exe -x $proxyServer -kfsL "$packageControlUrl" -o "$tmpFile"

  if (!$?) {
    Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
    Write-Host "Failed download the 'Package Control' file." -ForegroundColor Red
  } else {
    if (!(Test-Path "$installedPackagesPath")) {
      New-Item -ItemType Directory -Path "$installedPackagesPath" | Out-Null
    }

    Move-Item -Path "$tmpFile" -Destination "$installedPackagesPath\"
  }
}
