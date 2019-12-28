@{

# Top  上偏移，相对于“居中”位置
# Left 左偏移，相对于“居中”位置
# --------------------------------
# Top Left 都为 0 时，Offset 可略去
Sizes = @{
  Width  = 870
  Height = 504
  Offset = @{
    Top  = 10
    Left = 25
  }
}

Settings = @{
  FileList = @{
    ArcColumnWidths = @{
      name  = @('DWord', 145) # 名称
      size  = @('DWord', 93)  # 大小
      psize = @('DWord', 93)  # 压缩后大小
      type  = @('DWord', 75)  # 类型
      mtime = @('DWord', 114) # 修改时间
      crc   = @('DWord', 70)  # CRC32
    }
    FileColumnWidths = @{
      name  = @('DWord', 145)
      size  = @('DWord', 93)
      type  = @('DWord', 75)
      mtime = @('DWord', 114)
    }
  }

  Interface = @{
    Comment = @{
      LeftBorder = @('DWord', 596) # 注释左边的宽度
    }
  }
}

}
