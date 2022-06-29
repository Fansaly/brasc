$ScriptFilePath = $PSScriptRoot
$PSScriptsPath = (Get-Item -Path $ScriptFilePath).Parent.Parent.FullName + '\.PSScripts'
$configFileName = "settings.json"

. "${PSScriptsPath}\Write-Message.ps1"


$code = 'code'
Get-Command -Name $code -ErrorAction Ignore | Out-Null

if (!$?) {
  Write-Host "`n  - " -ForegroundColor Gray -NoNewLine
  Write-Host "``Visual Studio Code' is not installed." -ForegroundColor Yellow
  exit
}


$global:config = @{
  UserDataDir = "$env:APPDATA\Code\User"

  Extensions = @(
    "Equinusocio.vsc-material-theme",
    "Equinusocio.vsc-material-theme-icons",
    "zhuangtongfa.Material-theme", # Atom's iconic One Dark theme
    "EditorConfig.EditorConfig",
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode-remote.vscode-remote-extensionpack",
    "JakeBecker.elixir-ls",
    "Vue.volar"
  )
}


$InstalledExtensions = @()
& "$code" --list-extensions | % { $InstalledExtensions += @($_) }
$Extensions = $config.Extensions | ? { -not $($InstalledExtensions -contains $_) }

if ($Extensions.Count -gt 0) {
  $Extensions | % {
    Write-Message "installing ``$_' ..."
    & "$code" --install-extension $_
  }
}

Copy-Item -Path "${ScriptFilePath}\${configFileName}" -Destination "$($config.UserDataDir)\"
