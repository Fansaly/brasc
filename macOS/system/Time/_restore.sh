#!/bin/bash

# time zone
timezone=$(ls -l /etc/localtime | sed -E 's/.*\/zoneinfo\/(.*)/\1/')

if [[ "$timezone" != "Asia/Shanghai" ]]; then
  sudo systemsetup -settimezone Asia/Shanghai &>/dev/null
fi

# sync time
server=time.apple.com
server=time.pool.aliyun.com

re="[+\-]?([0-9]+\.[0-9]+)[[:space:]]*[+/\-]+[[:space:]]*([0-9]+\.[0-9]+)[[:space:]]*([-_.a-zA-Z0-9]+)[[:space:]]*(.*)"
rs=$(sntp $server 2>/dev/null | grep $server)

offset=$(echo "$rs" | sed -E "s/$re/\1/")
# delay=$(echo "$rs" | sed -E "s/$re/\2/")
# server=$(echo "$rs" | sed -E "s/$re/\3/")
# ip=$(echo "$rs" | sed -E "s/$re/\4/")

awk 'BEGIN {code=('$offset' < 0.5) ? 0 : 1; exit} END {exit code}'

if [[ $? -ne 0 ]]; then
  switch=$(sudo systemsetup -getusingnetworktime | sed -E 's/.*:[[:space:]]*(.*)/\1/')

  if [[ "$switch" =~ ^[Oo]n$ ]]; then
    sudo sntp -S $server >/dev/null 2>&1
  else
    sudo systemsetup -setusingnetworktime on &>/dev/null
  fi
fi


# show date and time in menu bar
# see in ../SysMenuExtras
defaults write com.apple.menuextra.clock "DateFormat" -string "EEE MMM d  HH:mm"
defaults write com.apple.menuextra.clock "FlashDateSeparators" -boolean False
defaults write com.apple.menuextra.clock "IsAnalog" -boolean False

[[ "$1" != "--norestart" ]] && killall SystemUIServer
