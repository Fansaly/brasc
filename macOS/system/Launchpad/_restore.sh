#!/bin/bash

# defaults write com.apple.dock springboard-columns -int 7
# defaults write com.apple.dock springboard-rows -int 5
# defaults write com.apple.dock ResetLaunchPad -bool TRUE
# killall Dock

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dbBackup=$currentDIR/db
dbTarget="$(find /private/var/folders -user $(id -u) -name com.apple.dock.launchpad 2>/dev/null)"

if [[ -d "$dbTarget" && -d "$dbBackup" ]]; then
  rm -rf "$dbTarget"/*
  cp -a "$dbBackup" "$dbTarget/"
  killall Dock
fi
