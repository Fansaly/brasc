function Merge-Object {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    $One = @{},
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    $Two = @{},
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch]
    $Override = $True
  )

  if ($One -isnot [hashtable] -or $Two -isnot [hashtable]) {
    if ($Override) {
      return $Two
    } else {
      return $One
    }
  }

  $Two.Keys | % {
    $key = $_

    if ($One.ContainsKey($key)) {
      $One.$key = Merge-Object $One.$key $Two.$key -Override:$Override
    } else {
      $One.$key = $Two.$key
    }
  }

  return $One
}
