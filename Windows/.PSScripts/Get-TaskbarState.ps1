function Get-TaskbarState {
  $Settings = @()

  $Path = (Resolve-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects*").Path

  (Get-ItemProperty -Path $Path -Name 'Settings').Settings | ForEach-Object -Begin { $i = 0; $arr = @() } -Process {
    $arr += $_

    if (++$i % 4 -eq 0) {
      $Settings += , $arr
      $arr = @()
    }
  } -End { Remove-Variable i, arr }

  if ($Settings[2][3] -eq 3) {
    $TaskbarAutoHide = $True
  } else {
    $TaskbarAutoHide = $False
  }

  switch ($Settings[3][0]) {
    0 { $TaskbarLocation = 'Left'; break }
    1 { $TaskbarLocation = 'Top'; break }
    2 { $TaskbarLocation = 'Right'; break }
    3 { $TaskbarLocation = 'Bottom'; break }
    default { break }
  }

  $TaskbarStartButtonWidth  = $Settings[4][0] + $Settings[4][1] * 256
  $TaskbarStartButtonHeight = $Settings[5][0] + $Settings[5][1] * 256

  $TaskbarLeft   = $Settings[6][0] + $Settings[6][1] * 256
  $TaskbarTop    = $Settings[7][0] + $Settings[7][1] * 256
  $TaskbarRight  = $Settings[8][0] + $Settings[8][1] * 256
  $TaskbarBottom = $Settings[9][0] + $Settings[9][1] * 256

  $TaskbarState = @{
    Left   = $TaskbarLeft
    Top    = $TaskbarTop
    Right  = $TaskbarRight
    Bottom = $TaskbarBottom
    Location = $TaskbarLocation
    AutoHide = $TaskbarAutoHide
    StartButton = @{
      Width  = $TaskbarStartButtonWidth
      Height = $TaskbarStartButtonHeight
    }
  }

  return $TaskbarState
}
