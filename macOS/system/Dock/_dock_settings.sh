#!/bin/bash
#
# Dock - settings

# Position
defaults write com.apple.dock "orientation" -string "bottom"

# Minimize windows
# ---------------------
# genie => Genie effect
# scale => Scale effect
defaults write com.apple.dock "mineffect" -string "genie"

# Preder tabs when opening documents
# ----------------------------------
# always     => Always
# fullscreen => In Full Screen Only
# manual     => Manually
defaults write -globalDomain "AppleWindowTabbingMode" -string "fullscreen"

# Double-click window's title bar
# -------------------------------
# Minimize => minimize
# Maximize => zomm
defaults write -globalDomain "AppleActionOnDoubleClick" -string "Maximize"

# Minimize windows into application icon
defaults write com.apple.dock "minimize-to-application" -boolean YES

# Animate opening applications
defaults write com.apple.dock "launchanim" -boolean YES

# Automatically hide and show Dock
defaults write com.apple.dock "autohide" -boolean NO

# Show indicators for open applications
defaults write com.apple.dock "show-process-indicators" -boolean YES

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
