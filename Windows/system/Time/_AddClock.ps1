$AdditionalClocks = @(
  @{
    DisplayName  = 'Seattle'
    Enable       = 1
    TzRegKeyName = 'Pacific Standard Time'
  }
)


$ClocksPath = 'HKCU:\Control Panel\TimeDate\AdditionalClocks'

if (!(Test-Path -Path ($ClocksPath | Split-Path))) {
  New-Item -Path ($ClocksPath | Split-Path) | Out-Null
}
if (!(Test-Path -Path $ClocksPath)) {
  New-Item -Path $ClocksPath | Out-Null
}

$Clocks = @()
$Clocks += Get-ChildItem -Path $ClocksPath | % {
  Get-ItemPropertyValue -Path "Registry::$_" -Name 'DisplayName'
}

$AdditionalClocks | % {
  $DisplayName  = $_.DisplayName
  $Enable       = $_.Enable
  $TzRegKeyName = $_.TzRegKeyName

  if (!$Clocks.Contains($DisplayName)) {
    $NewClockPath = "$ClocksPath\$($Clocks.Count + 1)"

    New-Item -Path $NewClockPath | Out-Null

    Set-ItemProperty -Path $NewClockPath -Type 'String' -Name 'DisplayName'  -Value $DisplayName
    Set-ItemProperty -Path $NewClockPath -Type 'DWord'  -Name 'Enable'       -Value $Enable
    Set-ItemProperty -Path $NewClockPath -Type 'String' -Name 'TzRegKeyName' -Value $TzRegKeyName
  }
}
