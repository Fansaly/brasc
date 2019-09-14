Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)


# https://www.getoutline.org
$URI = 'https://raw.githubusercontent.com/Jigsaw-Code/outline-releases/master/manager/stable/Outline-Manager.exe'
$OutFile = $URI | Split-Path -Leaf

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $URI -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -fSL "$URI" -o "$OutFile"
}
