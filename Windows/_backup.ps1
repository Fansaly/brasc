# .PARAMETER WriteOnceTips
# printed at least once tips
Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $WriteOnceTips = $False
)

function Write-Tips {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Tips,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch]
    $Flag = $global:WriteOnceTips
  )

  $global:WriteOnceTips = $True

  if ($Flag) {
    Write-Host "`n¡¤ " -ForegroundColor Gray -NoNewLine
  } else {
    Write-Host "¡¤ " -ForegroundColor Gray -NoNewLine
  }

  Write-Host " backup " -ForegroundColor Gray -BackgroundColor DarkGreen -NoNewLine
  Write-Host " ${Tips}" -ForegroundColor White -NoNewLine
  Write-Host " ... " -ForegroundColor Gray -NoNewLine
}


if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}

$systemPath = "$currentPath\system"

if (!(Test-Path -Path $systemPath)) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``system' directory doesn't exist." -ForegroundColor Yellow
  exit
}


# set PowerShell execution policy and source script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned


Write-Tips 'StartLayout'
. "${systemPath}\StartLayout\_backup.ps1"

Write-Tips 'Notifications Action Center'
. "${systemPath}\Notifications_Action_Center\_backup.ps1"

Write-Tips 'Windows PowerShell Shortcut'
. "${systemPath}\Shell\PSShortcut.ps1" -Action 'Backup'

Write-Tips 'TaskManager'
. "${systemPath}\TaskManager\_backup.ps1"
