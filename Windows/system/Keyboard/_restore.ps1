$defaultLang = 'en-US'
$langList = Get-WinUserLanguageList | % { $_.LanguageTag }

# set en-US keyboard to default keyboard layout
if ($langList[0] -ne $defaultLang) {
  $newLangList  = @( $defaultLang )
  $newLangList += $langList | ? { $_ -ne $defaultLang }

  Set-WinUserLanguageList -LanguageList $newLangList -Force
}

# use different input method for each app window
if (!(Get-WinLanguageBarOption).IsLegacySwitchingMode) {
  Set-WinLanguageBarOption -UseLegacySwitchMode
}
