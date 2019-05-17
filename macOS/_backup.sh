#!/bin/bash

function ECHO() {
  echo -e "\033[0;36m$1\033[0m $2 \033[0;37m... \033[0m"
}

masterDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
systemDIR=$masterDIR/system
appsDIR=$masterDIR/apps
unixDIR=$masterDIR/../Unix


ECHO "backup" "Sublime Text"
source "$appsDIR/SublimeText/_backup.sh"


echo
echo -e "\033[0;7m all done. \033[0m"
echo
