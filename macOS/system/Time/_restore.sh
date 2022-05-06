#!/bin/bash

# time zone
timezone=$(sudo systemsetup -gettimezone | sed -e 's/.*:[[:space:]]*\(.*\)/\1/')

if [[ "$timezone" != "Asia/Shanghai" ]]; then
  sudo systemsetup -settimezone Asia/Shanghai &>/dev/null
fi

# sync time
switch=$(sudo systemsetup -getusingnetworktime | sed -e 's/.*:[[:space:]]*\(.*\)/\1/')

if [[ ! "$switch" =~ [Oo]n ]]; then
  sudo systemsetup -setusingnetworktime on &>/dev/null
fi

# show date and time in menu bar
# see in ../SysMenuExtras
defaults write com.apple.menuextra.clock "DateFormat" -string "EEE MMM d  HH:mm"
defaults write com.apple.menuextra.clock "FlashDateSeparators" -boolean False
defaults write com.apple.menuextra.clock "IsAnalog" -boolean False

[[ "$1" != "--norestart" ]] && killall SystemUIServer
