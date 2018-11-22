# https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/147
function Invoke-PinToTaskbar {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Path,
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [switch]
    $UnPin = $False
  )

  if (![IO.File]::Exists($Path)) { return }

  $WShell = New-Object -ComObject 'WScript.Shell'
  $IsPinned = Get-ChildItem -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.lnk" | ? {
    $Path -eq $WShell.CreateShortcut($_.FullName).TargetPath
  }

  if ((!$UnPin -and $IsPinned) -or ($UnPin -and !$IsPinned)) { return }

  $VerbName  = '(UN)PIN'
  $HKCUShell = 'HKCU:\Software\Classes\*\shell'
  $HKLMShell = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell'

  # add pin/unpin handler into ContextMenu
  $CommandHandler = Get-ItemPropertyValue -Path "$HKLMShell\Windows.taskbarpin" -Name 'ExplorerCommandHandler'
  New-Item -Path "$HKCUShell\$VerbName" -Force | Out-Null
  Set-ItemProperty -LiteralPath "$HKCUShell\$VerbName" -Name 'ExplorerCommandHandler' -Type 'String' -Value $CommandHandler

  $ItemFolder   = Split-Path $Path
  $ItemFullName = Split-Path $Path -Leaf

  # do what you want to do pin/unpin
  $AppShell = New-Object -ComObject 'Shell.Application'
  $Item = $AppShell.NameSpace($ItemFolder).ParseName($ItemFullName)
  $Item.InvokeVerb($VerbName)

  # remove the handler
  Remove-Item -LiteralPath "$HKCUShell\$VerbName"
  if ((Get-ChildItem -LiteralPath $HKCUShell).Count -eq 0) {
    Remove-Item -LiteralPath $HKCUShell
  }
}
