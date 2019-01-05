#!/bin/bash
#
# Dock - settings

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptsDIR=$currentDIR/../../.scripts

source "$scriptsDIR/irXml.sh"

prefDIR=~/Library/Preferences
domain=com.apple.dock
plist=$prefDIR/$domain.plist

orgXmlCtx=$(plutil -convert xml1 -o - "$plist")
newXmlCtx="$orgXmlCtx"

# Position
newXmlCtx=$(irXml "orientation" -string "bottom" "$newXmlCtx")

# Minimize windows
# ---------------------
# genie => Genie effect
# scale => Scale effect
newXmlCtx=$(irXml "mineffect" -string "genie" "$newXmlCtx")

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
newXmlCtx=$(irXml "minimize-to-application" -bool YES "$newXmlCtx")

# Animate opening applications
newXmlCtx=$(irXml "launchanim" -bool YES "$newXmlCtx")

# Automatically hide and show Dock
newXmlCtx=$(irXml "autohide" -bool NO "$newXmlCtx")

# Show indicators for open applications
newXmlCtx=$(irXml "show-process-indicators" -bool YES "$newXmlCtx")

if [[ "$newXmlCtx" != "$orgXmlCtx" ]]; then
  echo "$newXmlCtx" | plutil -convert binary1 -o "$plist" -
fi

unset newXmlCtx orgXmlCtx

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
