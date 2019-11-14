$defaultLang = 'zh-Hans-CN'
$defaultInputMethod = @{
  LanguageTag    = 'en-US'
  InputMethodTip = '0409:00000409'
}

$langList = Get-WinUserLanguageList | % { $_.LanguageTag }

# sets the language list
if ($langList[0] -ne $defaultLang) {
  $newLangList  = @( $defaultLang )
  $newLangList += $langList | ? { $_ -ne $defaultLang }

  Set-WinUserLanguageList -LanguageList $newLangList -Force
}

# sets the default input method override
if ((Get-WinDefaultInputMethodOverride).InputMethodTip -ne $defaultInputMethod.InputMethodTip) {
  Set-WinDefaultInputMethodOverride -InputTip $defaultInputMethod.InputMethodTip
}

# use different input method for each app window
if (!(Get-WinLanguageBarOption).IsLegacySwitchingMode) {
  Set-WinLanguageBarOption -UseLegacySwitchMode
}
