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
    Write-Host "`n°§" -ForegroundColor Gray -NoNewLine
  } else {
    Write-Host "°§" -ForegroundColor Gray -NoNewLine
  }

  Write-Host " downloading " -ForegroundColor Cyan -NoNewLine
  Write-Host " ${Tips} " -ForegroundColor Magenta -BackgroundColor Gray -NoNewLine
  Write-Host " ... " -ForegroundColor Gray -NoNewLine
}


$downloadsPath  = "${PSScriptRoot}\@Downloads"
$downloadToPath = "$HOME\Downloads"


Push-Location -Path $downloadToPath

Write-Tips 'Google Chrome'
. "${downloadsPath}\_Chrome.ps1"

Write-Tips 'Õ¯“◊‘∆“Ù¿÷'
. "${downloadsPath}\_NeteaseMusic.ps1"

Write-Tips '∞Ÿ∂»Õ¯≈Ã'
. "${downloadsPath}\_BaiduNetdisk.ps1"

Write-Tips 'Outline Manager'
. "${downloadsPath}\_OutlineManager.ps1"

Pop-Location

Write-Host "`n  download to " -ForegroundColor Gray -NoNewLine
Write-Host $downloadToPath -ForegroundColor Yellow -NoNewLine
