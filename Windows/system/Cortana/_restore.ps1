Param (
  [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [switch]
  $NoRestart = $False
)


$Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
$Name = 'SearchboxTaskbarMode'
$Type = 'DWord'

# 任务栏 Cortana
# 0 => 隐藏
# 1 => 显示图标
# 2 => 显示搜索框
$Value = 1

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value

if (!$NoRestart) {
  Stop-Process -Name 'explorer'
}
