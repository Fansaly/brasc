#!/bin/bash
#
# Dock - persistent apps
# Custom Dock's persistent apps

# persistent apps ordered list
apps=(
  "Siri"
  "Launchpad"
  "Safari"
  "Google Chrome"
  "Mail"
  "Contacts"
  "Calendar"
  "Notes"
  "Reminders"
  "Maps"
  "Photos"
  "Messages"
  "FaceTime"
  "iTunes"
  "iBooks"
  "App Store"
  "System Preferences"
  "Terminal"
  "Sublime Text"
)

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
scriptsDIR=$currentDIR/../../.scripts

source "$scriptsDIR/urldecode.sh"

prefDIR=~/Library/Preferences
domain=com.apple.dock
plist=$prefDIR/$domain.plist

dictsApple=$(cat "$currentDIR/apps-dicts-apple.plist")
dicts3rd=$(cat "$currentDIR/apps-dicts-3rd.plist")
dicts='<dict><key>dicts</key><array/></dict>'

for (( i = 0; i < ${#apps[@]}; i++ )); do
  app=${apps[$i]}

  # app Dock dict of apple apps
  dict=$(echo "$dictsApple" | plutil -extract "$app" xml1 -o - -)

  if [[ $? -ne 0 ]]; then
    # app Dock dict of 3rd apps
    dict=$(echo "$dicts3rd" | plutil -extract "$app" xml1 -o - -)

    if [[ $? -ne 0 ]]; then
      echo -e "  \033[0;35m$app\033[0;33m Dock dict\033[0m doesn't exists."
      continue
    fi
  fi

  # app address
  target=$(urldecode "$( \
    echo "$dict" | \
    plutil -extract "tile-data.file-data._CFURLString" xml1 -o - - | \
    plutil -p - | \
    sed -e 's/"//g' \
  )" )

  re='^(file|(http(s)?)):\/\/(.*)$'
  protocol=$(echo "$target" | sed -E "s/$re/\1/")
  app_path=$(echo "$target" | sed -E "s/$re/\4/")

  if [[ "$protocol" == "file" && ! -d "$app_path" ]]; then
    echo -e "  \033[0;35m$app\033[0;33m isn't installed.\033[0m"
    continue
  fi

  # merge
  dicts=$(echo "$dicts" | plutil -insert "dicts.$i" -xml "$dict" -o - -)
done

# extract and save to Dock Preferences
dicts=$(echo "$dicts" | plutil -extract "dicts" xml1 -o - -)
plutil -replace "persistent-apps" -xml "$dicts" "$plist"

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
