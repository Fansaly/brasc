if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$computerName = Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Computername\Computername' -Name 'Computername'
$folderName = $currentPath | Split-Path -Leaf
$name = 'StartLayout'

if ($folderName -ne $name) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``${name}' isn't name of current directory." -ForegroundColor Yellow
  exit
}


Push-Location -Path $currentPath

if (!(Test-Path -Path $computerName)) {
  New-Item -Path $computerName -ItemType Directory | Out-Null
}

$regPath = "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount"
$regFile = "${computerName}\${name}.reg"

REG EXPORT $regPath $regFile /y | Out-Null
Copy-Item -Path "$HOME\AppData\Local\Microsoft\Windows\Shell\DefaultLayouts.xml" -Destination "${computerName}\"

Pop-Location
