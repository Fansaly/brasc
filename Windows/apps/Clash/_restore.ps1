$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'

. "${PSScriptsPath}\Get-PermissionStatus.ps1"
. "${ScriptFilePath}\Get-Config.ps1"


$config = Get-Config

if ($config.Count -eq 0) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Clash for Windows.exe' file doesn't exist." -ForegroundColor Yellow
  exit
}

$isRunning = Get-Process | Where-Object ProcessName -Match $config.name

if (!$isRunning) {
  Start-Process -FilePath $config.app
}


if (!$(Get-PermissionStatus)) { exit }


$ruleName = $config.coreName
$ruleProgram = $config.coreApp

Get-NetFirewallRule -DisplayName "*clash*" | ? {
    $_.Name -match "$ruleName" -or $_.DisplayName -match "$ruleName"
} | Remove-NetFirewallRule | Out-Null

New-NetFirewallRule `
  -Name "$ruleName TCP" `
  -DisplayName "$ruleName" `
  -Description "$ruleName" `
  -Direction Inbound `
  -Profile Private, Public `
  -Enabled True `
  -Action Allow `
  -Protocol TCP `
  -Program "$ruleProgram" `
  -EdgeTraversalPolicy DeferToUser `
  | Out-Null

New-NetFirewallRule `
  -Name "$ruleName UDP" `
  -DisplayName "$ruleName" `
  -Description "$ruleName" `
  -Direction Inbound `
  -Profile Private, Public `
  -Enabled True `
  -Action Allow `
  -Protocol UDP `
  -Program "$ruleProgram" `
  -EdgeTraversalPolicy DeferToUser `
  | Out-Null
