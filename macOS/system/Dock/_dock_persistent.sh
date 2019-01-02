#!/bin/bash
#
# Dock - persistent apps etc.

# https://www.rosettacode.org/wiki/URL_decoding
urldecode() { local u="${1//+/ }"; printf '%b' "${u//%/\\x}"; }

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

domain=com.apple.dock
prefDIR=~/Library/Preferences
plist=$prefDIR/$domain.plist


# Custom Dock's persistent apps
# -----------------------------
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
  fi

  if [[ $? -ne 0 ]]; then
    echo -e "  \033[0;35m$app\033[0;33m Dock dict\033[0m doesn't exists."
    continue
  fi

  # app install directory
  appDIR=$(urldecode "$( \
    echo "$dict" | \
    plutil -extract "tile-data.file-data._CFURLString" xml1 -o - - | \
    plutil -p - | \
    sed -e 's/"//g' | \
    sed -E 's/^file:\/\/(.*)$/\1/' \
  )" )

  if [[ ! -d "$appDIR" ]]; then
    echo -e "  \033[0;35m$app\033[0;33m isn't installed.\033[0m"
    continue
  fi

  # merge
  dicts=$(echo "$dicts" | plutil -insert "dicts.$i" -xml "$dict" -o - -)
done

# extract and save to Dock Preferences
dicts=$(echo "$dicts" | plutil -extract "dicts" xml1 -o - -)
plutil -replace "persistent-apps" -xml "$dicts" "$plist"


# Custom Dock's persistent `Downloads' style
persistent_others=$(plutil -extract "persistent-others" xml1 -o - "$plist")
persistent_others=$( \
  echo '<dict><key>persistent-others</key><array/></dict>' | \
  plutil -replace "persistent-others" -xml "$persistent_others" -o - - \
)

count=$(echo "$persistent_others" | xpath "count(//array/dict)" 2>/dev/null)
[[ ! "$count" =~ ^[0-9]+$ ]] && count=0

for (( i = 0; i < $count; i++ )); do
  entry=persistent-others.$i
  label=$( \
    echo "$persistent_others" | \
    plutil -extract "$entry.tile-data.file-label" xml1 -o - - | \
    plutil -p - | \
    sed -e 's/"//g' \
  )

  if [[ "$label" == "Downloads" ]]; then
    setting=$(echo "$persistent_others" | plutil -extract "$entry" xml1 -o - -)

    # NOTICE
    # this below command didn't execute correctly and return the error:
    # <-[__NSCFConstantString characterAtIndex:]: Range or index out of bounds>
    # plutil -replace "$entry.tile-data.arrangement" -integer 2 "$plist"
    # -------------------------------------------------------------------------
    # or use PlistBuddy
    # it will convert plist format from "binary" to "xml"
    # but you can still convert back to previous format
    # use command with: `plutil -convert binary1 "$plist"'
    # /usr/libexec/PlistBuddy -c "Set :$(echo $entry.tile-data.arrangement | sed -e 's/\./:/g') 2" "$plist"

    # Sort by
    # ---------
    # 1 => Name
    # 2 => Date Added
    # 3 => Date Modified
    # 4 => Date Created
    # 5 => Kind
    setting=$(echo "$setting" | plutil -replace "tile-data.arrangement" -integer 2 -o - -)

    # Display as
    # -----------
    # 0 => Stack
    # 1 => Folder
    setting=$(echo "$setting" | plutil -replace "tile-data.displayas" -integer 1 -o - -)

    # View Content as
    # ---------------
    # 1 => Fan
    # 2 => Grid
    # 3 => List
    # 0 => Automatic
    setting=$(echo "$setting" | plutil -replace "tile-data.showas" -integer 0 -o - -)

    persistent_others=$(echo "$persistent_others" | plutil -remove "$entry" -o - -)
    persistent_others=$(echo "$persistent_others" | plutil -replace "$entry" -xml "$setting" -o - -)
    persistent_others=$(echo "$persistent_others" | plutil -extract "persistent-others" xml1 -o - -)

    # save to Dock Preferences
    plutil -replace "persistent-others" -xml "$persistent_others" "$plist"

    break
  fi
done

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
