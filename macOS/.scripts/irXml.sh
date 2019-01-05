#!/bin/bash

# replace value into `dict' property list
# if keypath doesn't exist, will
# automatically create it
# and then insert value
function irXml() {
  local entry="$1"
  local type="$2"
  local value="$3"
  local xmlCtx="$4"
  local idx=$5
  local keys _entry_

  # split keypath if it has depth level
  IFS='♠' read -r -a keys <<< "$(echo "$entry" | sed -E 's/\./♠/g; s/\\♠/\\\./g')"

  # check keypath is exists
  echo "$xmlCtx" | plutil -extract "$entry" xml1 -o - - &>/dev/null

  # keypath exists or it's root key
  if [[ $? -eq 0 || ${#keys[@]} -eq 1 ]]; then
    # replace or insert value
    echo "$(echo "$xmlCtx" | plutil -replace "$entry" $type "$value" -o - -)"
  else
    # depth level
    [[ ! "$idx" =~ ^[0-9]+$ ]] && idx=0
    ((idx++))

    for (( i = 0; i < $idx; i++ )); do
      if [[ $i -eq 0 ]]; then
        _entry_="${keys[$i]}"
      elif [[ $idx -le ${#keys[@]} ]]; then
        _entry_+=."${keys[$i]}"
      else
        echo -e "\033[0;31mBoom!\033[0m"
        return 8
      fi
    done

    # create keypath if it doesn't exists
    echo "$xmlCtx" | plutil -extract "$_entry_" xml1 -o - - &>/dev/null
    if [[ $? -ne 0 ]]; then
      # will be throw `Boom!' when parent type isn't dict
      xmlCtx=$(echo "$xmlCtx" | plutil -replace "$_entry_" -xml "<dict/>" -o - -)
    fi

    # recursive call
    irXml "$entry" $type "$value" "$xmlCtx" $idx
  fi
}
