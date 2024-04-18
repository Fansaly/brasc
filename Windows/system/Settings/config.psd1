@{

RegPath = 'HKCU:\Software'

Settings = @{
  Microsoft = @{
    Windows = @{
      CurrentVersion = @{
        Explorer = @{
          Advanced = @{
            # 聊天
            # 0 => 关
            # 1 => 开
            TaskbarMn = @('DWord', 0)
            # 显示桌面
            # 0 => 关闭
            # 1 => 开启
            TaskbarSd = @('DWord', 1)

            # 个性化 → 开始 → 在“开始”、“跳转列表”和“文件资源管理器”中显示最近打开的项目
            # 0 => 关
            # 1 => 开
            Start_TrackDocs = @('DWord', 0)
            # 个性化 → 任务栏 → Copilot
            # 0 => 关
            # 1 => 开
            ShowCopilotButton = @('DWord', 0)
            # 个性化 → 任务栏 → 小组件
            # 0 => 关
            # 1 => 开
            TaskbarDa = @('DWord', 0)

            # Windows 10 and below
            # --------------------
            # 合并任务栏按钮
            # 0 => 始终合并按钮
            # 1 => 任务栏已满时
            # 2 => 从不
            TaskbarGlomLevel = @('DWord', 0)
            # 锁定任务栏
            # 0 => 锁定
            # 1 => 不锁定
            TaskbarSizeMove = @('DWord', 0)
            # 小任务栏图标
            # 0 => 否
            # 1 => 是
            TaskbarSmallIcons = @('DWord', 0)
            # 速览桌面
            # 0 => 开启
            # 1 => 关闭
            DisablePreviewDesktop = @('DWord', 0)
          }

          # 通知区域始终显示所有图标
          # 0 => 是
          # 1 => 否
          EnableAutoTray = @('DWord', 1)
        }

        # 任务栏 → 资讯和兴趣
        # 0 => 显示图标和文本
        # 1 => 仅显示图标
        # 2 => 关闭
        Feeds = @{
          ShellFeedsTaskbarViewMode = @('DWord', 2)
        }

        # 任务栏 → 搜索
        # 0 => 隐藏
        # 1 => 仅“搜索图标”
        # 2 => 搜索框
        # 3 => 搜索图标和标签
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
  }

  Policies = @{
    Microsoft = @{
      Windows = @{
        Explorer = @{
          # Disable Search Web
          # 0 => enabled
          # 1 => disabled
          DisableSearchBoxSuggestions = @('DWord', 1)
        }
      }
    }
  }
}

}
