function Get-Config {
  $Path = @{}
  $installPaths = @(
    "$env:LocalAppdata\Applications\Clash",
    "$env:ProgramW6432\Clash",
    "D:\Applications\Clash"
  )

  $installPaths | % {
    if ([IO.File]::Exists("$_\Clash for Windows.exe")) {
      $installPath = $_

      $Path = @{
        name = "Clash for Windows"
        app = "$installPath\Clash for Windows.exe"
        install = $installPath
      }

      return
    }
  }

  return $Path
}
