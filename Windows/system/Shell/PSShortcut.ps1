Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [ValidateSet('Backup', 'Restore')]
  [string]
  $Action
)


if (![String]::IsNullOrEmpty($PSScriptRoot)) {
  $currentPath = $PSScriptRoot
} else {
  $currentPath = (Get-Item -Path './').FullName
}


if ($Action -eq 'Backup') {
  Copy-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -Destination "$currentPath\"
} elseif ($Action -eq 'Restore') {
  Copy-Item -Path "$currentPath\Windows PowerShell.lnk" -Destination "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\"
}
