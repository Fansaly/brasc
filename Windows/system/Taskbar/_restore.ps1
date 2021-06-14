Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$RootPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion'

# 任务栏
$Item = @(
  # 搜索
  # 0 => 隐藏
  # 1 => 显示搜索图标
  # 2 => 显示搜索框
  @{
    Path = 'Search'
    Name = 'SearchboxTaskbarMode'
    Type = 'DWord'
    Value = 0
  }

  # 资讯和兴趣
  # 0 => 显示图标和文本
  # 1 => 仅显示图标
  # 2 => 关闭
  @{
    Path = 'Feeds'
    Name = 'ShellFeedsTaskbarViewMode'
    Type = 'DWord'
    Value = 2
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
