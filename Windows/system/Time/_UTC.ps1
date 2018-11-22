$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$hasAdmPermissions = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$hasAdmPermissions) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "Please run as Administrator." -ForegroundColor Yellow
  exit
}


$Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation'
$Name = 'RealTimeIsUniversal'
$Type = 'DWord'

# https://wiki.archlinux.org/index.php/System_time
# 0 => localtime
# 1 => UTC
$Value = 1

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value


# sync system time
$Status = (Get-Service -Name 'W32Time').Status

if ($Status -ne 'Running') {
  Start-Service -Name 'W32Time'
}

w32tm.exe /resync 2>&1 | Out-Null

if ($Status -ne (Get-Service -Name 'W32Time').Status) {
  Set-Service -Name 'W32Time' -Status $Status
}
