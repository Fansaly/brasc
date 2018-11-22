function Confirm-YesOrNo {
  $YesOrNo = ''

  while (!(@('y', 'n') -contains $YesOrNo)) {
    Write-Host '  -' -ForegroundColor Gray -NoNewLine
    Write-Host ' Do you want to continue?' -NoNewLine
    Write-Host ' (y/n)' -ForegroundColor Gray -NoNewLine
    Write-Host ': ' -NoNewLine

    $YesOrNo = Read-Host
    $YesOrNo = $YesOrNo.Trim()[0]
  }

  return $YesOrNo
}
