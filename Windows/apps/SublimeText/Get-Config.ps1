function Get-Config {
  $Path = @{}
  $installPaths = @(
    "$env:LocalAppdata\Applications\Sublime Text",
    "$env:ProgramW6432\Sublime Text",
    "D:\Applications\Sublime Text"
  )

  $installPaths | % {
    if ([IO.File]::Exists("$_\sublime_text.exe")) {
      $installPath = $_

      $Path = @{
        configPath = "${PSScriptRoot}\config"

        installPath = $installPath
        sublimeApp = "${installPath}\sublime_text.exe"

        installedPackagesPath = "${installPath}\Data\Installed Packages"
        packagesUserPath = "${installPath}\Data\Packages\User"
        packageControlFile = "Package Control.sublime-package"
      }

      return
    }
  }

  return $Path
}
