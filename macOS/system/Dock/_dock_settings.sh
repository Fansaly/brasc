#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptsDIR=$currentDIR/../../.scripts

source "$scriptsDIR/irXml.sh"

prefDIR=~/Library/Preferences
domain=com.apple.dock
plist=$prefDIR/$domain.plist

orgXmlCtx=$(plutil -convert xml1 -o - "$plist")
newXmlCtx="$orgXmlCtx"


# SysPref -> General
# ===================
# Preder tabs: when opening documents
# ----------------------------------
# always     => always
# fullscreen => in full screen
# manual     => never
defaults write -globalDomain "AppleWindowTabbingMode" -string "fullscreen"


# SysPref -> Dock & Menu bar
# ===========================
# Position
newXmlCtx=$(irXml "orientation" -string "bottom" "$newXmlCtx")

# Minimize windows
# ---------------------
# genie => Genie effect
# scale => Scale effect
newXmlCtx=$(irXml "mineffect" -string "genie" "$newXmlCtx")

# Double-click window's title bar
# -------------------------------
# Minimize => minimize
# Maximize => zomm
defaults write -globalDomain "AppleActionOnDoubleClick" -string "Maximize"

# Minimize windows into application icon
newXmlCtx=$(irXml "minimize-to-application" -bool YES "$newXmlCtx")

# Animate opening applications
newXmlCtx=$(irXml "launchanim" -bool YES "$newXmlCtx")

# Automatically hide and show Dock
newXmlCtx=$(irXml "autohide" -bool NO "$newXmlCtx")

# Show indicators for open applications
newXmlCtx=$(irXml "show-process-indicators" -bool YES "$newXmlCtx")

# Show recent applications in Dock
newXmlCtx=$(irXml "show-recents" -bool NO "$newXmlCtx")


# SysPref -> Mission Control
# ===========================
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
# newXmlCtx=$(irXml "wvous-tl-corner" -integer 0 "$newXmlCtx")
# newXmlCtx=$(irXml "wvous-tr-corner" -integer 0 "$newXmlCtx")
newXmlCtx=$(irXml "wvous-bl-corner" -integer 11 "$newXmlCtx")
newXmlCtx=$(irXml "wvous-br-corner" -integer 4 "$newXmlCtx")


if [[ "$newXmlCtx" != "$orgXmlCtx" ]]; then
  echo "$newXmlCtx" | plutil -convert binary1 -o "$plist" -
fi

unset newXmlCtx orgXmlCtx

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
