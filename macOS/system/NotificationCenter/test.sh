#!/bin/bash

# currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# prefDIR=~/Library/Preferences
# domainNotification=com.apple.notificationcenterui
# domainWorldClock=com.apple.ncplugin.WorldClock
# domainWeather=com.apple.ncplugin.weather
# plist=$prefDIR/$domainNotification.plist

# plutil -replace "TodayView.preferences.com\.apple\.nc\.today\.summary.enabled" -xml "<false/>" "$plist"
# plutil -replace "TodayView.preferences.com\.apple\.nc\.tomorrow\.summary.enabled" -xml "<false/>" "$plist"

# cp "$currentDIR/$domainWorldClock.plist" "$HOME/Library/Containers/$domainWorldClock/Data/Library/Preferences/"

# killall NotificationCenter
