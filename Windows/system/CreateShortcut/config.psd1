@{

  Programs = @(
    @{
      Name = 'Realtek ¸ßÇåÎúÒôÆµ¹ÜÀíÆ÷'
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
      Name = 'Postman'
      Path = @(
        'D:\Applications\Postman\Postman.exe'
      )
      Location = '$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Postman'
    },
    @{
      Name = 'DBeaver'
      Path = 'D:\Applications\dbeaver\dbeaver.exe'
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
      Name = 'Î¢ÐÅ'
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
      Name = 'Ñ¸À×'
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
      Name = '±©Ñ©Õ½Íø'
      Path = 'D:\Applications\Blizzard\Battle.net\Battle.net Launcher.exe'
    }
  )

}
