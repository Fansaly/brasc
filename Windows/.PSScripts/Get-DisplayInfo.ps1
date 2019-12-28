. "${PSScriptRoot}\Get-TaskbarState.ps1"

function Get-PrimaryDisplayInfo {
  $source =
@"
  using System;
  using System.Runtime.InteropServices;
  public class PInvoke {
    [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr hwnd);
    [DllImport("gdi32.dll")]  public static extern int GetDeviceCaps(IntPtr hdc, int nIndex);
  }
"@

  if (-not ([System.Management.Automation.PSTypeName]'PInvoke').Type) {
    Add-Type -TypeDefinition $source
  }

  # http://pinvoke.net/default.aspx/gdi32/GetDeviceCaps.html
  $DeviceCap = @{
    # Horizontal width in pixels
    HORZRES = 8
    # Vertical height in pixels
    VERTRES = 10
    # Number of bits per pixel
    BITSPIXEL = 12
    # Logical pixels inch in X
    LOGPIXELSX = 88
    # Logical pixels inch in Y
    LOGPIXELSY = 90
    # Actual color resolution
    COLORRES = 108
    # Current vertical refresh rate of the display device (for displays only) in Hz
    VREFRESH = 116
    # Vertical height of entire desktop in pixels
    DESKTOPVERTRES = 117
    # Horizontal width of entire desktop in pixels
    DESKTOPHORZRES = 118
  }

  $hdc = [PInvoke]::GetDC([IntPtr]::Zero)

  $PhysicalScreenWidth  = [PInvoke]::GetDeviceCaps($hdc, $DeviceCap.DESKTOPHORZRES)
  $PhysicalScreenHeight = [PInvoke]::GetDeviceCaps($hdc, $DeviceCap.DESKTOPVERTRES)
  $LogicalScreenWidth   = [PInvoke]::GetDeviceCaps($hdc, $DeviceCap.HORZRES)
  $LogicalScreenHeight  = [PInvoke]::GetDeviceCaps($hdc, $DeviceCap.VERTRES)
  $PixelsPerInchX = [PInvoke]::GetDeviceCaps($hdc, $DeviceCap.LOGPIXELSX)
  $BitsPerPixel = [PInvoke]::GetDeviceCaps($hdc, $DeviceCap.BITSPIXEL)

  $Resolution = "$($PhysicalScreenWidth)x$($PhysicalScreenHeight)"
  $LogicalResolution = "$($LogicalScreenWidth)x$($LogicalScreenHeight)"
  $ScreenScalingFactor = [float] ($PhysicalScreenWidth / $LogicalScreenWidth)

  $AvailWidth = $PhysicalScreenWidth
  $AvailHeight = $PhysicalScreenHeight
  $TaskbarState = Get-TaskbarState

  if (@('Top', 'Bottom').Contains($TaskbarState.Location)) {
    $AvailHeight -= $TaskbarState.StartButton.Height
  } else {
    $AvailWidth -= $TaskbarState.StartButton.Width
  }

  return @{
    Width = $PhysicalScreenWidth
    Height = $PhysicalScreenHeight
    AvailWidth = $AvailWidth
    AvailHeight = $AvailHeight
    Resolution = $Resolution
    LogicalWidth = $LogicalScreenWidth
    LogicalHeight = $LogicalScreenHeight
    LogicalResolution = $LogicalResolution
    ScreenScalingFactor = $ScreenScalingFactor
    PixelsPerInch = [int] (96 * $ScreenScalingFactor) # $PixelsPerInchX
    BitsPerPixel = $BitsPerPixel
  }
}
