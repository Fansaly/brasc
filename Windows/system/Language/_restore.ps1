$defaultDisplayLang = @{
  LanguageTag    = 'zh-Hans-CN'
  InputMethodTip = '0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411F-A5AC-CA038EC515D7}'
}
$defaultInputLang = @{
  LanguageTag    = 'en-US'
  InputMethodTip = '0409:00000409'
}

$defaultLang = $defaultDisplayLang.LanguageTag

$langList = @(
  $defaultDisplayLang,
  $defaultInputLang
)

$currLangList = Get-WinUserLanguageList | % { $_.LanguageTag }

$newList = @()
$newList = $currLangList | ? { -not $langList -contains $_ }

$targetList = @()
$targetList += $langList | % { $_.LanguageTag }
$targetList += $newList

# sets the language list
if ($($currLangList -join ',') -ne $($targetList -join ',')) {
  Set-WinUserLanguageList -LanguageList $targetList -Force
}

# sets the default input method override
if ((Get-WinDefaultInputMethodOverride).InputMethodTip -ne $defaultInputLang.InputMethodTip) {
  Set-WinDefaultInputMethodOverride -InputTip $defaultInputLang.InputMethodTip
}

# use different input method for each app window
if (!(Get-WinLanguageBarOption).IsLegacySwitchingMode) {
  Set-WinLanguageBarOption -UseLegacySwitchMode
}
