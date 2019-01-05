#!/bin/bash
#
# date time
# ---------
# show date and time in menu bar
# see in ../SysMenuExtras

defaults write com.apple.menuextra.clock "DateFormat" -string "EEE MMM d  HH:mm"
defaults write com.apple.menuextra.clock "FlashDateSeparators" -boolean False
defaults write com.apple.menuextra.clock "IsAnalog" -boolean False

[[ "$1" != "--norestart" ]] && killall SystemUIServer
