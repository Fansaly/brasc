. "${PSScriptRoot}\Get-PermissionStatus.ps1"

function Disable-StartupItem {
  Param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    $Path = @('HKCU','HKLM'),
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Name
  )

  $Name = $Name.Trim()
  if ([String]::IsNullOrEmpty($Name)) { exit }

  $Path | % {
    $regPath = "${_}:\SOFTWARE\Microsoft\Windows\CurrentVersion"
    $startupPath = "${regPath}\Run"
    $startupApprovedPath = "${regPath}\Explorer\StartupApproved\Run"

    $itemName = Get-Item -Path $startupPath | Select-Object -ExpandProperty Property | ? {
      $_ -match $Name
    }

    if ([bool]$itemName) {
      $item = Get-ItemProperty -Path $startupApprovedPath | Select-Object $itemName

      if (![bool]$item.$itemName -or $item.$itemName[0] -ne 3) {
        if ($_ -eq 'HKLM' -and !$(Get-PermissionStatus)) { exit }
        Set-ItemProperty -Path $startupApprovedPath -Name $itemName -value @(3,0,0,0,0,0,0,0,0,0,0,0)
      }
    }
  }
}
