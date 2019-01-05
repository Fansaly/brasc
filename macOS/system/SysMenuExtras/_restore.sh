#!/bin/bash
#
# enable system apps menu extra

function getCorrectMenuName() {
  local menu="$1"
  local correct_menu=$( \
    ls "/System/Library/CoreServices/Menu Extras" | \
    grep -i "^$menu.menu$" | \
    sed -E 's/^(.*)\.menu$/\1/' \
  )

  if [[ -n "$correct_menu" ]]; then
    echo "$correct_menu"
  else
    return 1
  fi
}

function setMenuExtrasArray() {
  local action="$1"
  local menu="$2"
  local xmlCtx="$3"
  local xmlVal
  local test

  # test action
  if [[ ! "$action" =~ ^((enable)|(disable))$ ]]; then
    echo -e "\033[0;31minvalid action.\033[0m"
    return 1
  fi

  # test directory
  xmlVal="/System/Library/CoreServices/Menu Extras/$menu.menu"
  if [[ ! -d "$xmlVal" ]]; then
    echo -e "\033[0;35m$menu \033[0;31mdirectory doesn't exists.\033[0m"
    return 1
  fi

  # test xml format
  test=$(echo "$xmlCtx" | plutil -lint - | sed -E 's/^.*(OK)$/\1/')
  if [[ "$test" != "OK" ]]; then
    echo -e "\033[0;31minvalid format.\033[0m"
    return 1
  fi

  xmlCtx=$( \
    echo '<dict><key>xml-key</key><array/></dict>' | \
    plutil -replace "xml-key" -xml "$xmlCtx" -o - - \
  )

  count=$(echo "$xmlCtx" | xpath "count(//array/string)" 2>/dev/null)
  [[ ! "$count" =~ ^[0-9]+$ ]] && count=0

  if [[ $count -gt 0 ]]; then
    for (( i = 0; i < $count; i++ )); do
      local _VAL_=$( \
        echo "$xmlCtx" | \
        plutil -extract "xml-key.$i" xml1 -o - - | \
        plutil -p - | \
        sed -e 's/"//g' \
      )

      # local name=$(echo "$_VAL_" | sed -E 's/^.*\/([^\/]+)\.menu$/\1/')

      if [[ "$_VAL_" == "$xmlVal" ]]; then
        if [[ "$action" == "disable" ]]; then
          xmlCtx=$(echo "$xmlCtx" | plutil -remove "xml-key.$i" -o - -)
        fi
        break
      elif [[ $(( $i + 1 )) -eq $count && "$action" == "enable" ]]; then
        xmlCtx=$(echo "$xmlCtx" | plutil -insert "xml-key.$count" -string "$xmlVal" -o - -)
      fi
    done
  elif [[ "$action" == "enable" ]]; then
    xmlCtx=$(echo "$xmlCtx" | plutil -insert "xml-key.0" -string "$xmlVal" -o - -)
  fi

  echo "$(echo "$xmlCtx" | plutil -extract "xml-key" xml1 -o - -)"
}

function setMenuExtra() {
  local prefDIR=~/Library/Preferences
  local domain=com.apple.systemuiserver
  local plist=$prefDIR/$domain.plist
  local action="$1"
  local menus menu
  shift
  menus=("$@")

  if [[ ! "$action" =~ ^((enable)|(disable))$ ]]; then
    echo -e "\033[0;31minvalid action.\033[0m"
    return 1
  fi

  local orgMenuExtras newMenuExtras
  orgMenuExtras=$(plutil -extract "menuExtras" xml1 -o - "$plist")

  for menu in "${menus[@]}"; do
    menu=$(getCorrectMenuName "$menu")
    newMenuExtras=$(setMenuExtrasArray "$action" "$menu" "$orgMenuExtras")

    # show/hide app in menu bar
    if [[ $? -eq 0 && "$newMenuExtras" != "$orgMenuExtras" ]]; then
      __RESTART__=true
      orgMenuExtras=$newMenuExtras
      menu=$(echo "$menu" | sed -e 's/ //g' | awk '{print tolower($0)}')

      plutil -replace "menuExtras" -xml "$newMenuExtras" "$plist"
      if [[ "$action" == "enable" ]]; then
        defaults write $domain "NSStatusItem Visible com.apple.menuextra.$menu" -boolean True
      else
        defaults delete $domain "NSStatusItem Visible com.apple.menuextra.$menu"
      fi
    fi
  done
}

menus=(
  "Clock"
  "Volume"
  "TextInput"
)
unset __RESTART__
setMenuExtra "enable" "${menus[@]}"

if [[ -n "$__RESTART__" && "$1" != "--norestart" ]]; then
  killall SystemUIServer
fi
