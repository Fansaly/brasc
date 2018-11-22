Get-Process | ? Name -Match 'OneDrive' | Stop-Process

$startupPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'

Get-Item -Path $startupPath `
| Select-Object -ExpandProperty Property `
| % {
  # remove OneDrive from Startup
  if ($_ -match 'OneDrive') {
    Remove-ItemProperty -Path $startupPath -Name $_
  }
}
