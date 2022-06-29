Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)

$UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
# $DateTime = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$URI = 'https://music.163.com/api/pc/package/download/latest'

$Response = curl.exe -A "$UserAgent" -fIs "$URI"

$Location = $Response -match '^Location:\s*http(s)?:\/\/.*$' -replace 'Location:\s*'
$OutFile = $Location | Split-Path -Leaf

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $Location -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -A "$UserAgent" -fSL "$Location" -o "$OutFile"
}
