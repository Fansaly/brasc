. "${PSScriptRoot}\Get-Config.ps1"

$config = Get-Config

if ($config.Count -eq 0 -or !(Test-Path $config.packagesUserPath)) { exit }

$configPath = $config.configPath
$installPath = $config.installPath
$packagesUserPath = $config.packagesUserPath

# Sublime project config file
Copy-Item -Path "$installPath\*.sublime-project" -Destination "$configPath\"

# Preferences, Key Bindings, Settings, etc
@(
  '*.sublime-settings',
  '*.sublime-keymap',
  '*.sublime-build'
) | % {
  Copy-Item -Path "$packagesUserPath\$_" -Destination "$configPath\Data\Packages\User\"
}
