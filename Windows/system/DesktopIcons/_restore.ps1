Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$pathHideDesktopIcons = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'

if (!(Test-Path -Path "$pathHideDesktopIcons\ClassicStartMenu")) {
  New-Item -Path "$pathHideDesktopIcons\ClassicStartMenu" | Out-Null
}

# https://www.tenforums.com/tutorials/3123-clsid-key-guid-shortcuts-list-windows-10-a.html
@(
  '{645FF040-5081-101B-9F08-00AA002F954E}' # Recycle Bin
) | % {
  Set-ItemProperty -Path "$pathHideDesktopIcons\ClassicStartMenu" -Name $_ -Type 'DWord' -Value 1
  Set-ItemProperty -Path "$pathHideDesktopIcons\NewStartPanel"    -Name $_ -Type 'DWord' -Value 1
}

# https://docs.microsoft.com/en-us/dotnet/api/system.environment.specialfolder
Get-ChildItem -Path "$([Environment]::GetFolderPath('Desktop'))\*.lnk" | % { Remove-Item -Path $_ }
Get-ChildItem -Path "$([Environment]::GetFolderPath('CommonDesktopDirectory'))\*.lnk" | % { Remove-Item -Path $_ }


if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
