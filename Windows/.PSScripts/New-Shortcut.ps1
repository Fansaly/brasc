function New-Shortcut {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Path,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Location,

    # number of current file icon index or a icon file path
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    $Icon = 0,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $WorkingDirectory,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Arguments,

    # 1 => Activates and displays a window. If the window is minimized or
    # maximized, the system restores it to its original size and position.
    # 3 => Activates the window and displays it as a maximized window.
    # 7 => Minimizes the window and activates the next top-level window.
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [int]
    $WindowStyle = 1,

    # .EXAMPLE Ctrl+Shift+C
    # Hotkeys can be used to start shortcuts located on your
    # system's desktop and in the Windows Start menu.
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Hotkey,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Description
  )

  if (![IO.File]::Exists([Environment]::ExpandEnvironmentVariables($Path))) { return }

  $Locations = @(
    'AllUsersDesktop',
    'AllUsersStartMenu',
    'AllUsersPrograms',
    'AllUsersStartup',
    'StartMenu',
    'Startup',
    'Desktop'
  )

  $WShell = New-Object -ComObject 'WScript.Shell'

  if ([String]::IsNullOrEmpty($Name)) {
    $Name = (Get-Item -Path $Path).BaseName
  }

  if ($Locations.Contains($Location)) {
    $Location = $WShell.SpecialFolders($Location)
  } elseif ([String]::IsNullOrEmpty($Location) -or !(Test-Path -Path $Location)) {
    $Location = $WShell.SpecialFolders('Desktop')
  }

  if ($Icon -match '^\d+$') {
    $Icon = "$Path, $Icon"
  }

  if ([String]::IsNullOrEmpty($WorkingDirectory)) {
    $WorkingDirectory = $Path | Split-Path
  }

  if (!@(1,3,7).Contains($WindowStyle)) {
    $WindowStyle = 1
  }

  $lnk = $WShell.CreateShortcut("$Location\$Name.lnk")
  $lnk.IconLocation     = $Icon
  $lnk.TargetPath       = $Path
  $lnk.Arguments        = $Arguments
  $lnk.WorkingDirectory = $WorkingDirectory
  # $lnk.Hotkey           = $Hotkey
  $lnk.WindowStyle      = $WindowStyle
  $lnk.Description      = $Description
  $lnk.Save()
}
