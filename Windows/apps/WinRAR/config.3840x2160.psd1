@{

# Top  上偏移，相对于“居中”位置
# Left 左偏移，相对于“居中”位置
# --------------------------------
# Top Left 都为 0 时，Offset 可略去
Sizes = @{
  Width  = 1500
  Height = 870
  Offset = @{
    Top  = 40
    Left = 30
  }
}

Settings = @{
  FileList = @{
    ArcColumnWidths = @{
      name  = @('DWord', 374) # 名称
      size  = @('DWord', 138) # 大小
      psize = @('DWord', 138) # 压缩后大小
      type  = @('DWord', 128) # 类型
      mtime = @('DWord', 170) # 修改时间
      crc   = @('DWord', 114) # CRC32
    }
    FileColumnWidths = @{
      name  = @('DWord', 374)
      size  = @('DWord', 138)
      type  = @('DWord', 128)
      mtime = @('DWord', 170)
    }
  }

  Interface = @{
    Comment = @{
      LeftBorder = @('DWord', 1066) # 注释左边的宽度
    }
  }
}

}
