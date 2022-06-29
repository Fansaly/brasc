Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$RootPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion'

$Item = @(
  # 任务栏 → 资讯和兴趣
  # 0 => 显示图标和文本
  # 1 => 仅显示图标
  # 2 => 关闭
  @{
    Path = 'Feeds'
    Name = 'ShellFeedsTaskbarViewMode'
    Type = 'DWord'
    Value = 2
  }

  # 任务栏 → 搜索
  # 0 => 隐藏
  # 1 => 显示搜索图标
  # 2 => 显示搜索框
  @{
    Path = 'Search'
    Name = 'SearchboxTaskbarMode'
    Type = 'DWord'
    Value = 0
  }

  # 设置 → 隐私和安全 → 搜索权限
  # ---------------------------
  # 云内容搜索(Micorosoft 账户)
  # 0 => 关闭
  # 1 => 开启
  @{
    Path = 'SearchSettings'
    Name = 'IsMSACloudSearchEnabled'
    Type = 'DWord'
    Value = 0
  }
  # 云内容搜索(工作或学校账户)
  # 0 => 关闭
  # 1 => 开启
  @{
    Path = 'SearchSettings'
    Name = 'IsAADCloudSearchEnabled'
    Type = 'DWord'
    Value = 0
  }
  # 历史记录(搜索历史记录)
  # 0 => 关闭
  # 1 => 开启
  @{
    Path = 'SearchSettings'
    Name = 'IsDeviceSearchHistoryEnabled'
    Type = 'DWord'
    Value = 0
  }
)

$Item | % {
  $Path = "$RootPath\$($_.Path)"

  if (Test-Path($Path)) {
    Set-ItemProperty -Path $Path -Name $_.Name -Type $_.Type -Value $_.Value
  }
}

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
