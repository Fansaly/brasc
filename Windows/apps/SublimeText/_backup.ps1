$configPath = "${PSScriptRoot}\config"
$installPath = 'D:\Applications\Sublime Text 3'
$packagesUserPath = "${installPath}\Data\Packages\User"

if (!(Test-Path "$packagesUserPath")) { exit }

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
