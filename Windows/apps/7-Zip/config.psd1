@{

# 7-Zip FM 窗口
UI = @{
  RegPath = 'HKCU:\Software\7-Zip\FM'

  # Top  对于“居中”位置的相上偏移量
  # Left 对于“居中”位置的相左偏移量
  # --------------------------------
  # Top, Left 均为 0 时 Offset 可省写
  Sizes = @{
    '2560x1440' = @{
      Width  = 1096
      Height = 636
      # 相对“居中”位置偏移
      Offset = @{
        Top  = 44
        Left = 55
      }
    }
    '1920x1080' = @{
      Width  = 870
      Height = 504
      # 相对“居中”位置偏移
      Offset = @{
        Top  = 10
        Left = 25
      }
    }
  }
}

RegPath = 'HKCU:\Software\7-Zip'
# 7-Zip settings
Settings = @{
  Options = @{
    CascadedMenu   = @('DWord', 1) # 层叠到右键菜单

    #   32 打开压缩包
    #   64 打开压缩包 >
    #    1 提取文件 ...
    #    2 提取到当前位置
    #    4 提取到 <文件夹>
    #   10 测试压缩包
    #  256 添加到压缩包 ...
    #  512 添加到 <档案>.7z
    # 4096 添加到 <档案>.zip
    # 1024 压缩并邮寄
    # 2048 压缩 <档案>.7z 并邮寄
    # 8192 压缩 <档案>.zip 并邮寄
    # 2147483648 CRC SHA >
    ContextMenu    = @('DWord', @(32,1,2,256))

    ElimDupExtract = @('DWord', 1) # 排除重复的根文件夹
    MenuIcons      = @('DWord', 1) # 右键菜单显示图标
  }
}

}
