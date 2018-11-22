$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$hasAdmPermissions = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$hasAdmPermissions) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please run as Administrator." -ForegroundColor Yellow
  exit
}

$sublimeApp = 'D:\Program Files\Sublime Text 3\sublime_text.exe'

if (![IO.File]::Exists($sublimeApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``sublime_text.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}

# Registry::HKEY_CLASSES_ROOT => HKLM:\Software\Classes
$sublimeRegPath = 'Registry::HKEY_CLASSES_ROOT\*\shell\SublimeText3'

New-Item -Path "${sublimeRegPath}\command" -Force | Out-Null
Set-ItemProperty -LiteralPath $sublimeRegPath -Type 'String' -Name '(Default)' -Value 'Open with Sublime Text'
Set-ItemProperty -LiteralPath $sublimeRegPath -Type 'String' -Name 'Icon'      -Value $sublimeApp
Set-ItemProperty -LiteralPath "${sublimeRegPath}\command" -Type 'String' -Name '(Default)' -Value "$sublimeApp `"%1`""


# set current path and scripts lib path
if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$PSScriptsPath = (Get-Item -Path $currentPath).Parent.Parent.FullName + '\.PSScripts'

if (!(Test-Path -Path $PSScriptsPath)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "PSScripts path doesn't exist." -ForegroundColor Yellow
  exit
}


# set PowerShell execution policy and source script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
. "${PSScriptsPath}\Invoke-PinToTaskbar.ps1"


# pin Sublime Text to taskbar
Invoke-PinToTaskbar $sublimeApp
