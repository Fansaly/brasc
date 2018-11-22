Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)


$URI = 'https://music.163.com/api/pc/download/latest'

try {
  Invoke-WebRequest -Uri $URI -UseBasicParsing
} catch {
  $Response = $_.Exception.Response
  $URI = $Response.ResponseUri.OriginalString.Split(',')[1]
}

$OutFile = $URI | Split-Path -Leaf

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $URI -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -fSL -o "$OutFile" "$URI"
}
