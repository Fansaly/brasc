function Set-Registry {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Path = '',
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [object]
    $Data,
    [Parameter(ValueFromPipelineByPropertyName)]
    [scriptblock]
    $CallBack
  )

  if ($Data -isnot [hashtable] -and $Data -isnot [array]) { return }

  if ($Data -is [array]) {
    $Type  = $Data[0]
    $Value = $Data[1]
    $Name  = $Path | Split-Path -Leaf
    $Path  = $Path | Split-Path

    if ($CallBack) {
      $Value = & $CallBack $Data
    }

    if ([String]::IsNullOrEmpty($Value)) { return }

    if (!(Test-Path -Path $Path)) {
      New-Item -Path $Path -Force | Out-Null
    }

    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
  } else {
    $Data.Keys | % {
      Set-Registry -Data $Data.$_ -Path "$Path\$_" -CallBack $CallBack
    }
  }
}
