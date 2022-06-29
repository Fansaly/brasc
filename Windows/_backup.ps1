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


$systemPath = "${PSScriptRoot}\system"
$appsPath   = "${PSScriptRoot}\apps"


# system configuration
Write-Tips 'Windows PowerShell Shortcut'
. "${systemPath}\Shell\PSShortcut.ps1" -Action 'Backup'

Write-Tips 'Windows Terminal'
. "${systemPath}\Terminal\_backup.ps1"


# apps configuration
Write-Tips 'Sublime Text'
. "${appsPath}\SublimeText\_backup.ps1"

Write-Tips 'Visual Studio Code'
. "${appsPath}\VSCode\_backup.ps1"
