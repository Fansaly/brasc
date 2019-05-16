Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)


$IID = "$(New-Guid)".ToUpper()

# https://www.google.com/intl/zh-CN/chrome/?standalone=1
$URI = @"
https://dl.google.com/tag/s/
appguid={8A69D345-D564-463C-AFF1-A69D9E530F96}
&iid={$IID}
&lang=zh-CN
&browser=4
&usagestats=0
&appname=Google%20Chrome
&needsadmin=prefers
&ap=x64-stable-statsdef_1
&installdataindex=empty/chrome/install/ChromeStandaloneSetup64.exe
"@

$URI = [Uri]::EscapeUriString(($URI -replace '\s',''))
$OutFile = $URI | Split-Path -Leaf

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $URI -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -k -fSL -o "$OutFile" "$URI"
}
