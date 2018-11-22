if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$appShell = New-Object -ComObject 'Shell.Application'
$sysFonts = $appShell.NameSpace(0x14)
$usrFonts = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

Get-ChildItem -Path $currentPath `
| Where-Object { @('.fon','.otf','.ttc','.ttf') -contains $_.Extension } `
| % {
  if (![IO.File]::Exists("$usrFonts\$_") -and ![IO.File]::Exists("$($sysFonts.Self.Path)\$_")) {
    $sysFonts.CopyHere($_.FullName)
  }
}
