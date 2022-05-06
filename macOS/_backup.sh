#!/bin/bash

function ECHO() {
  echo -e "\033[0;36m$1\033[0m $2 \033[0;37m... \033[0m"
}

masterDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
systemDIR=$masterDIR/system
appsDIR=$masterDIR/apps
unixDIR=$masterDIR/../Unix


FLAG=$@
F_COMMON=true
F_LAUNCHPAD=false

if [[ $FLAG == "all" || $FLAG == "launchpad" ]]; then
  F_LAUNCHPAD=true
fi
if [[ $FLAG == "launchpad" ]]; then
  F_COMMON=false
fi


if [[ $F_LAUNCHPAD == "true" ]]; then
  ECHO "backup" "Launchpad"
  source "$systemDIR/Launchpad/_backup.sh"
fi

if [[ $F_COMMON == "true" ]]; then
  ECHO "backup" "Sublime Text"
  source "$appsDIR/SublimeText/_backup.sh"
fi


echo
echo -e "\033[0;7m all done. \033[0m"
echo
