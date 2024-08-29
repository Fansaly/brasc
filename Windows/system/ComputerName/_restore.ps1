$PSScriptsPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Get-PermissionStatus.ps1"

if (!$(Get-PermissionStatus)) { exit }


$names = @{
  '{74d92ec2-e06d-4957-a9e8-7aa1b0b1a904}' = 'YOGAPro'
}

$computerActiveName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\ActiveComputerName' -Name 'Computername'
$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'

Get-Disk | Where-Object 'IsBoot' -EQ 'True' | Select-Object 'Guid' | % {
  $guid = $_.Guid

  if ($names.ContainsKey($guid)) {
    $name = $names.Item($guid)

    if ($name -ne $computerName) {
      Rename-Computer -NewName $name -WarningAction 'SilentlyContinue'

      if ($? -eq $True) {
        Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
        Write-Host "$computerActiveName" -ForegroundColor DarkCyan -NoNewLine
        Write-Host " -> " -ForegroundColor Gray -NoNewLine
        Write-Host "$name" -ForegroundColor DarkCyan -NoNewLine
        Write-Host " take effect after reboot computer" -ForegroundColor Yellow
      }
    }
  }
}
