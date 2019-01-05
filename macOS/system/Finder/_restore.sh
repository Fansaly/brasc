#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptsDIR=$currentDIR/../../.scripts

source "$scriptsDIR/irXml.sh"

prefDIR=~/Library/Preferences
domain=com.apple.finder
plist=$prefDIR/$domain.plist

orgXmlCtx=$(plutil -convert xml1 -o - "$plist")
newXmlCtx="$orgXmlCtx"

# siderbar width
newXmlCtx=$(irXml "SidebarWidth" -float 190 "$newXmlCtx")

# new window
newXmlCtx=$(irXml "NewWindowTarget" -string "PfHm" "$newXmlCtx")
newXmlCtx=$(irXml "NewWindowTargetPath" -string "file://$HOME/" "$newXmlCtx")

# siderbar Tags
newXmlCtx=$(irXml "ShowRecentTags" -bool False "$newXmlCtx")
newXmlCtx=$(irXml "SidebarTagsSctionDisclosedState" -bool False "$newXmlCtx")

# standard sort type <Name>
newXmlCtx=$(irXml "FXPreferredGroupBy" -string "Name" "$newXmlCtx")
newXmlCtx=$(irXml "StandardViewSettings.IconViewSettings.arrangeBy" -string "Name" "$newXmlCtx")

# desktop devices icon <hide all>
newXmlCtx=$(irXml "ShowExternalHardDrivesOnDesktop" -bool False "$newXmlCtx")
newXmlCtx=$(irXml "ShowRemovableMediaOnDesktop" -bool False "$newXmlCtx")
newXmlCtx=$(irXml "ShowHardDrivesOnDesktop" -bool False "$newXmlCtx")

# desktop sort type <Grid>
newXmlCtx=$(irXml "DesktopViewSettings.IconViewSettings.arrangeBy" -string "grid" "$newXmlCtx")

if [[ "$newXmlCtx" != "$orgXmlCtx" ]]; then
  # restore Finder
  echo "$newXmlCtx" | plutil -convert binary1 -o "$plist" -

  [[ "$1" != "--norestart" ]] && killall Finder
fi

unset newXmlCtx orgXmlCtx
