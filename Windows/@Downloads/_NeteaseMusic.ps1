Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)


$URI = 'https://music.163.com/api/pc/download/latest'

$Response = curl.exe -fIs "$URI"
$Location = $Response -match '^Location:\s*http(s)?:\/\/.*$' -replace 'Location:\s*'
$OutFile = $Location | Split-Path -Leaf
$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36"

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $URI -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -fSL "$URI" -o "$OutFile" -A "$UserAgent"
}
