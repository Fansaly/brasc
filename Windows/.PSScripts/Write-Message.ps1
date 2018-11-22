# .PARAMETER WriteOnceMessage
# printed at least once message
Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $WriteOnceMessage = $False
)

# custom Write-Host
function Write-Message {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Message,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch]
    $Flag = $global:WriteOnceMessage
  )

  $global:WriteOnceMessage = $True

  if ($Flag) {
    Write-Host "  - " -ForegroundColor Gray -NoNewLine
  } else {
    Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  }

  Write-Host $Message -ForegroundColor Yellow
}
