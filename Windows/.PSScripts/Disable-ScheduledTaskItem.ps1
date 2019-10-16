. "${PSScriptRoot}\Get-PermissionStatus.ps1"

function Disable-ScheduledTaskItem {
  Param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $TaskPath = '\',
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $TaskName
  )

  $TaskName = $TaskName.Trim()
  if ([String]::IsNullOrEmpty($TaskName)) { exit }

  # $TaskName = $TaskName -replace '\s+','\s+'
  $task = Get-ScheduledTask -TaskPath $TaskPath | ? { $_.TaskName -match $TaskName }

  if ([bool]$task -and $task.State -ne 'Disabled') {
    if (!$(Get-PermissionStatus)) { exit }

    $task | Stop-ScheduledTask
    $task | Disable-ScheduledTask | Out-Null
  }
}
