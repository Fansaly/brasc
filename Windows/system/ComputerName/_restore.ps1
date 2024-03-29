$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Get-PermissionStatus.ps1"

if (!$(Get-PermissionStatus)) { exit }


$names = @{
  '{28c6c309-dffb-4ebb-b053-319479331354}' = 'XiaoXinPro'
}

$computerActiveName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputerName' -Name 'Computername'
$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'

Get-Disk | Where-Object 'IsBoot' -EQ 'True' | Select-Object 'Guid' | % {
  $guid = $_.Guid

  if ($names.ContainsKey($guid)) {
    $name = $names.Item($guid)

    if ($name -ne $computerName) {
      Rename-Computer -NewName $name -WarningAction 'SilentlyContinue'

      Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
      Write-Host "$computerActiveName" -ForegroundColor DarkCyan -NoNewLine
      Write-Host " -> " -ForegroundColor Gray -NoNewLine
      Write-Host "$name" -ForegroundColor DarkCyan -NoNewLine
      Write-Host " take effect after reboot computer" -ForegroundColor Yellow
    }
  }
}
