@{

# Windows Explorer
UI = @{
  RegPath = 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell'

  # Top  上偏移，相对于“居中”位置
  # Left 左偏移，相对于“居中”位置
  # --------------------------------
  # Top Left 都为 0 时，Offset 可略去
  Sizes = @{
    '3840x2160' = @{
      Width  = 2220
      Height = 1278
      Offset = @{
        Top  = 10
        Left = 10
      }
    }
    '2560x1440' = @{
      Width  = 1480
      Height = 852
      Offset = @{
        Top  = 20
        Left = 20
      }
    }
    '1920x1080' = @{
      Width  = 1280
      Height = 742
    }
  }
}

# Windows Explorer and Taskbar
RegPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
Settings = @{
  # 通知区域始终显示所有图标
  # 0 => 是
  # 1 => 否
  EnableAutoTray = @('DWord', 1)
  # “快速访问”中显示常用文件夹
  # 0 => 是
  # 1 => 否
  ShowFrequent = @('DWord', 0)
  # “快速访问”中显示最近使用的文件
  # 0 => 是
  # 1 => 否
  ShowRecent = @('DWord', 0)

  Advanced = @{
    # 速览桌面
    # 0 => 开启
    # 1 => 关闭
    DisablePreviewDesktop = @('DWord', 0)
    # 隐藏的文件、文件夹
    # 1 => 显示
    # 2 => 隐藏
    Hidden = @('DWord', 1)
    # 隐藏已知文件类型的扩展名
    # 0 => 显示
    # 1 => 隐藏
    HideFileExt = @('DWord', 0)
    # 打开“资源管理器”时打开
    # 1 => 此电脑
    # 2 => 快速访问
    LaunchTo = @('DWord', 1)
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
  }

  Modules = @{
    GlobalSettings = @{
      DetailsContainer = @{
        # 显示-详细信息窗格
        # [0]=1, [4]=2
        # ---------------
        # 显示-预览窗格
        # [0]=2, [4]=1
        # ---------------
        # 隐藏-窗格
        # [0]=2, [4]=2
        DetailsContainer = @(
          'Binary',
          @(
            1,0,0,0,
            2,0,0,0
          )
        )
      }
      Sizer = @{
        # 导航窗格
        # [4]=0 => 隐藏
        # [4]=1 => 显示
        PageSpaceControlSizer = @(
          'Binary',
          @(
            160,0,0,0,
            1,0,0,0,
            0,0,0,0,
            164,4,0,0
          )
        )
      }
    }
  }

  Ribbon = @{
    # 功能区
    # 0 => 展开
    # 1 => 收起
    MinimizedStateTabletModeOff = @('DWord', 1)
  }
}

}
