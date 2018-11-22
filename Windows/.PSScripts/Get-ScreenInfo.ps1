function Get-ScreenInfo {
  Param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch]
    $IsPrimary = $False
  )

  $Screens = @()

  [void] [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
  [void] [Reflection.Assembly]::LoadWithPartialName("System.Drawing")
  [system.windows.forms.screen]::AllScreens | ForEach-Object {
    $Screen = @{
      DeviceName   = $_.DeviceName
      BitsPerPixel = $_.BitsPerPixel
      IsPrimary    = $_.Primary
      Width        = $_.Bounds.Width
      Height       = $_.Bounds.Height
      AvailWidth   = $_.WorkingArea.Width
      AvailHeight  = $_.WorkingArea.Height
      Resolution   = "$($_.Bounds.Width)x$($_.Bounds.Height)"
    }

    if ($IsPrimary -and $Screen.IsPrimary) {
      return $Screen
    }

    $Screens += , $Screen
  }

  return $Screens
}
