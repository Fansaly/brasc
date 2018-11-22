$steamServiceApp = 'D:\Program Files\Steam\bin\steamservice.exe'
if (![IO.File]::Exists($steamServiceApp)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``SteamService.exe' application doesn't exist." -ForegroundColor Yellow
  exit
}

$service = Get-Service | Where-Object Name -Match 'Steam'
if (!$service) {
  Start-Process -FilePath $steamServiceApp -ArgumentList '/install' -WindowStyle Hidden -Wait
}

$regPath = 'HKCU:\Software\Valve\Steam'

if (!(Test-Path -Path ($regPath | Split-Path))) {
  New-Item -Path ($regPath | Split-Path) | Out-Null
}

if (!(Test-Path -Path $regPath)) {
  New-Item -Path $regPath | Out-Null

  Set-ItemProperty -Path $regPath -Type 'String' -Name 'AutoLoginUser' -Value ''
  Set-ItemProperty -Path $regPath -Type 'String' -Name 'Language'      -Value 'schinese'
  Set-ItemProperty -Path $regPath -Type 'String' -Name 'SkinV4'        -Value 'Metro for Steam'
}
