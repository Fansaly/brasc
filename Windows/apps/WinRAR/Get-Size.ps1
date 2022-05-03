function Get-Size {
  Param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [hashtable]
    $DisplayInfo
  )

  if ($DisplayInfo -isnot [hashtable]) { return }

  $AvailWidth  = $DisplayInfo.AvailWidth
  $AvailHeight = $DisplayInfo.AvailHeight

  $Width  = [Math]::Round($AvailWidth * 0.5)
  $Height = [Math]::Round($AvailHeight * 0.5)
  $Top    = [Math]::Round($AvailHeight * 0.012)
  $Left   = [Math]::Round($AvailWidth * 0.01)

  $name  = [Math]::Round($Width * 0.2)    # 名称
  $size  = [Math]::Round($Width * 0.108)  # 大小
  $psize = [Math]::Round($Width * 0.108)  # 压缩后大小
  $type  = [Math]::Round($Width * 0.086)  # 类型
  $mtime = [Math]::Round($Width * 0.132)  # 修改时间
  $crc   = [Math]::Round($Width * 0.081)  # CRC32

  $LeftBorder = $name + $size + $psize + $type + $mtime + $crc + 4 # 注释左边的宽度
  $LeftBorder = [Math]::Min($LeftBorder, $Width)

  return @{
    Sizes = @{
      Width  = $Width
      Height = $Height
      Offset = @{
        Top  = $Top
        Left = $Left
      }
    }

    Settings = @{
      FileList = @{
        ArcColumnWidths = @{
          name  = @('DWord', $name)
          size  = @('DWord', $size)
          psize = @('DWord', $psize)
          type  = @('DWord', $type)
          mtime = @('DWord', $mtime)
          crc   = @('DWord', $crc)
        }
        FileColumnWidths = @{
          name  = @('DWord', $name)
          size  = @('DWord', $size)
          type  = @('DWord', $type)
          mtime = @('DWord', $mtime)
        }
      }

      Interface = @{
        Comment = @{
          LeftBorder = @('DWord', $LeftBorder)
        }
      }
    }
  }
}
