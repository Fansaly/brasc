Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)

# https://code.visualstudio.com/Download
$URI = @"
https://code.visualstudio.com/sha/download
?build=stable
&os=win32-x64-user
"@


$URI = [Uri]::EscapeUriString(($URI -replace '\s',''))
$Response = curl.exe -fIs "$URI"
$Location = $Response -match '^Location:\s*http(s)?:\/\/.*$' -replace 'Location:\s*'
$Location = $Location -replace '\/\/.*\.msecnd\.net\/', '//vscode.cdn.azure.cn/'
$OutFile = $Location | Split-Path -Leaf

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $Location -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -k -fSL -o "$OutFile" "$Location"
}
