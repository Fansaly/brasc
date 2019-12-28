@{

# Top  上偏移，相对于“居中”位置
# Left 左偏移，相对于“居中”位置
# --------------------------------
# Top Left 都为 0 时，Offset 可略去
Sizes = @{
  Width  = 1096
  Height = 636
  Offset = @{
    Top  = 44
    Left = 55
  }
}

Settings = @{
  FileList = @{
    ArcColumnWidths = @{
      name  = @('DWord', 250) # 名称
      size  = @('DWord', 92)  # 大小
      psize = @('DWord', 92)  # 压缩后大小
      type  = @('DWord', 85)  # 类型
      mtime = @('DWord', 114) # 修改时间
      crc   = @('DWord', 76)  # CRC32
    }
    FileColumnWidths = @{
      name  = @('DWord', 250)
      size  = @('DWord', 92)
      type  = @('DWord', 85)
      mtime = @('DWord', 114)
    }
  }

  Interface = @{
    Comment = @{
      LeftBorder = @('DWord', 730) # 注释左边的宽度
    }
  }
}

}
