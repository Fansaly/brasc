#!/bin/bash
#
# Mission Control

# Dashboard
# ---------
# 1 => Off
# 2 => As Space
# 3 => As Overlay
defaults write com.apple.dashboard "dashboard-enabled-state" -integer 3

# Hot Corners
# ---------------------------
# Mission Control      =>  2
# Application Windows  =>  3
# Desktop              =>  4
# Dashboard            =>  7
# Notification Center  => 12
# ---------------------------
# Launchpad            => 11
# ---------------------------
# Start Screen Saver   =>  5
# Disable Screen Saver =>  6
# ---------------------------
# Put Display to Sleep => 10
# ---------------------------
# -                    =>  1
# ---------------------------
# defaults write com.apple.dock "wvous-tl-corner" -integer 0
# defaults write com.apple.dock "wvous-tr-corner" -integer 0
defaults write com.apple.dock "wvous-bl-corner" -integer 11
defaults write com.apple.dock "wvous-br-corner" -integer 4

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
