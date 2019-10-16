$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'


. "${PSScriptsPath}\Get-PermissionStatus.ps1"
. "${PSScriptsPath}\Write-Message.ps1"


if (!$(Get-PermissionStatus)) { exit }


# setting SystemDrive Volume
$SystemDrive = $env:SystemDrive[0]
$SystemLabel = (Get-Volume -DriveLetter $SystemDrive).FileSystemLabel
if ($SystemLabel -ne 'Windows OS') {
  Set-Volume -DriveLetter $SystemDrive -NewFileSystemLabel 'Windows OS'
}


$configFile = "${ScriptFilePath}\config.psd1"

if (![IO.File]::Exists($configFile)) { exit }

$partitions = Import-PowerShellDataFile $configFile

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'

if (!$partitions.ContainsKey($computerName)) { exit }


# setting partitions DriveLetter
$targetPartitions = $partitions.Item($computerName)

$diffPartitions = $targetPartitions | ? {
  $_disk      = $_.DiskNumber
  $_partition = $_.PartitionNumber
  $_drive     = $_.DriveLetter
  $_volume    = $_.FileSystemLabel

  Get-Partition -DiskNumber $_disk -PartitionNumber $_partition | Get-Volume | ? {
    $_.DriveLetter -ne $_drive -or $_.FileSystemLabel -ne $_volume
  }
}

if ($diffPartitions) {
  $drivesUsed = (Get-Volume).DriveLetter -match '\w'

  $drivesAssignment = $diffPartitions | % { $_.DriveLetter }

  $drives = [byte][char]'C' .. [byte][char]'Z' | % { [char]$_ }

  $drivesUsable = $drives -match "[^$drivesUsed]" -match "[^$drivesAssignment]"
  $drivesUsable = Get-Random $drivesUsable -Count $drivesAssignment.Count

  if ($diffPartitions -is [array]) {
    $diffPartitions | % -Begin { $i = 0 } -Process {
      $_disk = $_.DiskNumber
      $_partition = $_.PartitionNumber

      Get-Partition -DiskNumber $_disk -PartitionNumber $_partition | Set-Partition -NewDriveLetter $drivesUsable[$i++]
    } -End { Remove-Variable i }
  }

  $diffPartitions | % -Begin { $drivesUsed = (Get-Volume).DriveLetter -match '\w' } -Process {
    $_disk      = $_.DiskNumber
    $_partition = $_.PartitionNumber
    $_drive     = $_.DriveLetter
    $_volume    = $_.FileSystemLabel

    if ($drivesUsed.Contains([char]$_drive)) {
      Write-Message "Drive ${_drive}: has been assigned."
    } else {
      Get-Partition -DiskNumber $_disk -PartitionNumber $_partition | Set-Partition -NewDriveLetter $_drive
    }
  }
}
