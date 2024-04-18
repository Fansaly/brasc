@{

  Programs = @(
    @{
      Name = 'Realtek 高清晰音频管理器'
      Path = '%ProgramFiles%\Realtek\Audio\HDA\RtkNGUI64.exe'
    },
    @{
      Name = 'Registry Workshop'
      Path = @(
        'D:\Applications\Registry Workshop\RegWorkshopX64.exe'
      )
    },
    @{
      Name = 'Beyond Compare'
      Path = @(
        '%ProgramFiles%\Beyond Compare\BCompare.exe',
        'D:\Applications\Beyond Compare\BCompare.exe'
      )
    },
    @{
      Name = 'HBuilderX'
      Path = @(
        'D:\Applications\HBuilderX\HBuilderX.exe'
      )
    },
    @{
      Name = 'Android Studio'
      Path = @(
        'D:\Applications\Android\android-studio\bin\studio64.exe'
      )
    },
    @{
      Name = 'IntelliJ IDEA'
      Path = @(
        'D:\Applications\ideaIU\bin\idea64.exe'
      )
    },
    @{
      Name = 'Internet Explorer'
      Path = @(
        '%ProgramFiles(x86)%\Internet Explorer\iexplore.exe'
      )
      Arguments = 'about:blank -Embedding'
    },
    @{
      Name = 'IEChooser'
      Path = '%SystemRoot%\System32\F12\IEChooser.exe'
    },
    @{
      Name = 'Telegram'
      Path = @(
        'D:\Applications\Telegram\Telegram.exe'
      )
    },
    @{
      Name = '微信'
      Path = @(
        '%ProgramFiles(x86)%\Tencent\WeChat\WeChat.exe',
        'D:\Applications\Tencent\WeChat\WeChat.exe'
      )
    },
    @{
      Name = 'QQ'
      Path = @(
        'D:\Applications\Tencent\QQ\Bin\QQScLauncher.exe'
      )
    },
    @{
      Name = 'Gopeed'
      Path = 'D:\Applications\Gopeed\gopeed.exe'
    },
    @{
      Name = '迅雷'
      Path = @(
        '%ProgramFiles(x86)%\ThunderX\Program\Thunder.exe',
        '%ProgramFiles(x86)%\Thunder\Program\Thunder.exe',
        'D:\Applications\ThunderX\Program\Thunder.exe',
        'D:\Applications\Thunder\Program\Thunder.exe'
      )
    },
    @{
      Name = 'Steam'
      Path = 'D:\Applications\Steam\Steam.exe'
    },
    @{
      Name = '暴雪战网'
      Path = 'D:\Applications\Blizzard\Battle.net\Battle.net Launcher.exe'
    }
  )

}
