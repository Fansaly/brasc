Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $UseWebRequest = $False
)


function ConvertTo-UnixDate($CDate) {
  $UDate = [timezone]::CurrentTimeZone.ToLocalTime([datetime]'1/1/1970')
  return [long](New-TimeSpan -Start $UDate -End $CDate).TotalMilliseconds
}

$time = ConvertTo-UnixDate(Get-Date)

$URI = "https://pan.baidu.com/disk/cmsdata?do=client&t=${time}&channel=chunlei&clienttype=0&web=1"
$URI = (Invoke-WebRequest -Uri $URI -UseBasicParsing | ConvertFrom-JSON).guanjia.url

$OutFile = $URI | Split-Path -Leaf

if ($UseWebRequest) {
  Invoke-WebRequest -Uri $URI -OutFile $OutFile -UseBasicParsing
} else {
  Write-Host "`n" -NoNewLine
  curl.exe -fSL -o "$OutFile" "$URI"
}
