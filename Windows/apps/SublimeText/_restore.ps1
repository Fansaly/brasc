$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Get-PermissionStatus.ps1"
. "${PSScriptsPath}\Invoke-PinToTaskbar.ps1"


if (!$(Get-PermissionStatus)) { exit }


$installPath = 'D:\Program Files\Sublime Text 3'
$sublimeApp = "$installPath\sublime_text.exe"

if (![IO.File]::Exists($sublimeApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``sublime_text.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}

# pin Sublime Text to taskbar
Invoke-PinToTaskbar $sublimeApp

# add 'Open with Sublime Text' to Context Menu
# Registry::HKEY_CLASSES_ROOT => HKLM:\Software\Classes
$sublimeRegPath = 'Registry::HKEY_CLASSES_ROOT\*\shell\SublimeText3'

New-Item -Path "${sublimeRegPath}\command" -Force | Out-Null
Set-ItemProperty -LiteralPath $sublimeRegPath -Type 'String' -Name '(Default)' -Value 'Open with Sublime Text'
Set-ItemProperty -LiteralPath $sublimeRegPath -Type 'String' -Name 'Icon'      -Value $sublimeApp
Set-ItemProperty -LiteralPath "${sublimeRegPath}\command" -Type 'String' -Name '(Default)' -Value "$sublimeApp `"%1`""

# Preferences, Key Bindings, Settings, etc
Copy-Item -Path "$ScriptFilePath\config\*" -Destination "$installPath\" -Recurse -Force

# Package Control
$packageControlFile = 'Package Control.sublime-package'
$installedPackagesPath = "$installPath\Data\Installed Packages"

if ([IO.File]::Exists("$installedPackagesPath/$packageControlFile")) { exit }

$packageControlUrl = 'https://packagecontrol.io/Package Control.sublime-package'
$proxyServer = 'socks5://127.0.0.1:1080'

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
