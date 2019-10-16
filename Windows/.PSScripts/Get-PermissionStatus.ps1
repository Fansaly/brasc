function Get-PermissionStatus {
  Param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch]
    $Silent = $False
  )

  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  $hasAdmPermission = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

  if ($hasAdmPermission) {
    return $True
  } else {
    if (!$Silent) {
      Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
      Write-Host "Permission denied." -ForegroundColor Yellow
    }
    return $False
  }
}
