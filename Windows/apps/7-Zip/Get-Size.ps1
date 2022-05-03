function Get-Size {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [hashtable]
    $DisplayInfo,
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [hashtable]
    $UISizes
  )

  if ($DisplayInfo -isnot [hashtable] -and $UISizes -isnot [hashtable]) { return }

  $AvailWidth  = $DisplayInfo.AvailWidth
  $AvailHeight = $DisplayInfo.AvailHeight

  if ($UISizes.ContainsKey($DisplayInfo.Resolution)) {
    $Sizes = $UISizes.Item($DisplayInfo.Resolution)
  } else {
    $Width  = [Math]::Round($AvailWidth * 0.5)
    $Height = [Math]::Round($AvailHeight * 0.5)
    $Top    = [Math]::Round($AvailHeight * 0.012)
    $Left   = [Math]::Round($AvailWidth * 0.01)

    if ($Width % 2 -ne 0) {
      $Width++
    }
    if ($Height % 2 -ne 0) {
      $Height++
    }

    $Sizes = @{
      Width  = $Width
      Height = $Height
      Offset = @{
        Top  = $Top
        Left = $Left
      }
    }
  }

  return $Sizes
}
