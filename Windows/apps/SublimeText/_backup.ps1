if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$configPath = "${currentPath}\config"
$installPath = 'D:\Program Files\Sublime Text 3'
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
