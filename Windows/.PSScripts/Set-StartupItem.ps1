. "${PSScriptRoot}\Get-PermissionStatus.ps1"

function Set-StartupItem {
  Param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateSet('Create','Enable','Disable','Remove')]
    [string]
    $Action,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    $Path = @('HKCU','HKLM'),
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Name,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Value
  )

  $Name = $Name.Trim()
  if ([String]::IsNullOrEmpty($Name)) { return }

  $Path | % {
    $rootPath = $_

    $regPath = "${rootPath}:\SOFTWARE\Microsoft\Windows\CurrentVersion"
    $startupPath = "${regPath}\Run"
    $startupApprovedPath = "${regPath}\Explorer\StartupApproved\Run"

    $startupName = $Null
    $startupApprovedValue = $Null

    $startupName = Get-Item -Path $startupPath | Select-Object -ExpandProperty Property | ? { $_ -match $Name }
    if ([bool]$startupName) {
      $startupApprovedValue = (Get-ItemProperty -Path $startupApprovedPath | Select-Object $startupName).$startupName
    }

    switch ($Action) {
      'Create' {
        if ([bool]$startupName) { break }
        if ($rootPath -eq 'HKLM' -and !$(Get-PermissionStatus)) { break }
        Set-ItemProperty -Path $startupPath -Name $Name -Value $Value -Type 'String'
      }
      'Enable' {
        if (![bool]$startupName -or ([bool]$startupApprovedValue -and $startupApprovedValue[0] -eq 2)) { break }
        if ($rootPath -eq 'HKLM' -and !$(Get-PermissionStatus)) { break }
        Set-ItemProperty -Path $startupApprovedPath -Name $startupName -Value @(2,0,0,0,0,0,0,0,0,0,0,0) -Type 'Binary'
      }
      'Disable' {
        if (![bool]$startupName -or ([bool]$startupApprovedValue -and $startupApprovedValue[0] -eq 3)) { break }
        if ($rootPath -eq 'HKLM' -and !$(Get-PermissionStatus)) { break }
        Set-ItemProperty -Path $startupApprovedPath -Name $startupName -Value @(3,0,0,0,0,0,0,0,0,0,0,0) -Type 'Binary'
      }
      'Remove' {
        if ([bool]$startupName) {
          if ($rootPath -eq 'HKLM' -and !$(Get-PermissionStatus)) { break }
          Remove-ItemProperty -Path $startupPath -Name $startupName
        }
        if ([bool]$startupApprovedValue) {
          if ($rootPath -eq 'HKLM' -and !$(Get-PermissionStatus)) { break }
          Remove-ItemProperty -Path $startupApprovedPath -Name $startupName
        }
      }
      default { break }
    }
  }
}
