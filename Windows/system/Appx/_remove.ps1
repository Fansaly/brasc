@(
  'Microsoft.BingNews',
  'Microsoft.Office.OneNote',
  'Microsoft.MicrosoftOfficeHub',

  # Netease-CloudMusic
  '1F8B0F94.122165AE053F'
) | % {
  Get-AppxPackage $_ | Remove-AppxPackage
}
