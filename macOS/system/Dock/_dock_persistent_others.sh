#!/bin/bash
#
# Dock - persistent others
# Custom Dock's persistent `Downloads' style

prefDIR=~/Library/Preferences
domain=com.apple.dock
plist=$prefDIR/$domain.plist

org_persistent_others=$(plutil -extract "persistent-others" xml1 -o - "$plist")
org_persistent_others=$( \
  echo '<dict><key>persistent-others</key><array/></dict>' | \
  plutil -replace "persistent-others" -xml "$org_persistent_others" -o - - \
)
new_persistent_others="$org_persistent_others"

count=$(echo "$new_persistent_others" | xpath "count(//array/dict)" 2>/dev/null)
[[ ! "$count" =~ ^[0-9]+$ ]] && count=0

for (( i = 0; i < $count; i++ )); do
  entry=persistent-others.$i
  label=$( \
    echo "$new_persistent_others" | \
    plutil -extract "$entry.tile-data.file-label" xml1 -o - - | \
    plutil -p - | \
    sed -e 's/"//g' \
  )

  if [[ "$label" == "Downloads" ]]; then
    setting=$(echo "$new_persistent_others" | plutil -extract "$entry" xml1 -o - -)

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

    new_persistent_others=$(echo "$new_persistent_others" | plutil -remove "$entry" -o - -)
    new_persistent_others=$(echo "$new_persistent_others" | plutil -replace "$entry" -xml "$setting" -o - -)
    new_persistent_others=$(echo "$new_persistent_others" | plutil -extract "persistent-others" xml1 -o - -)

    break
  fi
done

if [[ "$new_persistent_others" != "$org_persistent_others" ]]; then
  # save to Dock Preferences
  plutil -replace "persistent-others" -xml "$new_persistent_others" "$plist"

  [[ "$1" != "--norestart" ]] && killall Dock
fi

unset new_persistent_others org_persistent_others
