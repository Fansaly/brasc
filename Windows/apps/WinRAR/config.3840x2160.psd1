@{

RegPath = 'HKCU:\Software\WinRAR'

# WinRAR 窗口
Sizes = @{
  Width  = 1500
  Height = 870
  # 相对“居中”位置偏移
  Offset = @{
    Top  = 40
    Left = 30
  }
}

# WinRAR settings
Settings = @{
  FileList = @{
    ArcColumnWidths = @{
      # 标签列宽
      name  = @('DWord', 374) # 名称
      size  = @('DWord', 138)  # 大小
      psize = @('DWord', 138)  # 压缩后大小
      type  = @('DWord', 128)  # 类型
      mtime = @('DWord', 170) # 修改时间
      crc   = @('DWord', 114)  # CRC32
    }
    FileColumnWidths = @{
      # 标签列宽
      name  = @('DWord', 374) # 名称
      size  = @('DWord', 138)  # 大小
      type  = @('DWord', 128)  # 类型
      mtime = @('DWord', 170) # 修改时间
    }
  }

  General = @{
    Toolbar = @{
      Lock = @('DWord', 1) # 锁定工具栏
    }
  }

  Interface = @{
    Comment = @{
      LeftBorder = @('DWord', 1066) # 注释栏左边距
    }
    MainWin = @{
      # 窗口位置
      Placement = @(
        'Binary',
        @(44,0,0,0,0,0,0,0,1,0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255),
        'Get-MainWindowPlacement'
      )
    }
  }

  Setup = @{
    CascadedMenu = @('DWord', 1) # 层叠右键关联菜单
    MenuItems = @{
      ExtrTo   = @('DWord', 1) # 解压文件
      ExtrHere = @('DWord', 1) # 解压到当前文件
      Extr     = @('DWord', 1) # 解压到<文件夹>
      ExtrSep  = @('DWord', 1) # 解压到单独文件夹
      OpenSFX  = @('DWord', 1) # 用 WinRAR 打开
      AddTo    = @('DWord', 1) # 添加到压缩文件中
      AddArc   = @('DWord', 1) # 添加到<压缩文件名>
      EmailArc = @('DWord', 0) # 压缩到<压缩文件名>并E－mial
      EmailOpt = @('DWord', 0) # 压缩并E－mial
      Test     = @('DWord', 0) # 测试压缩文件
      Convert  = @('DWord', 0) # 转换压缩文件
    }
  }
}

}
