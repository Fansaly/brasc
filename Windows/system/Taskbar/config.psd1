@{

RegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion'

Settings = @{
  # 任务栏 → 资讯和兴趣
  # 0 => 显示图标和文本
  # 1 => 仅显示图标
  # 2 => 关闭
  Feeds = @{
    ShellFeedsTaskbarViewMode = @('DWord', 2)
  }

  # 任务栏 → 搜索
  # 0 => 隐藏
  # 1 => 显示搜索图标
  # 2 => 显示搜索框
  Search = @{
    SearchboxTaskbarMode = @('DWord', 0)
  }

  # 设置 → 隐私和安全 → 搜索权限
  SearchSettings = @{
    # 云内容搜索(Micorosoft 账户)
    # 0 => 关闭
    # 1 => 开启
    IsMSACloudSearchEnabled = @('DWord', 0)

    # 云内容搜索(工作或学校账户)
    # 0 => 关闭
    # 1 => 开启
    IsAADCloudSearchEnabled = @('DWord', 0)

    # 历史记录(搜索历史记录)
    # 0 => 关闭
    # 1 => 开启
    IsDeviceSearchHistoryEnabled = @('DWord', 0)

    # 更多设置(显示搜索要点)
    # 0 => 关闭
    # 1 => 开启
    IsDynamicSearchBoxEnabled = @('DWord', 0)
  }
}

}
