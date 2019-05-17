#!/bin/bash

function ECHO() {
  echo -e "\033[0;36mdownloading\033[0m $1 \033[0;37m... \033[0m"
}

masterDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
downloadsDIR=$masterDIR/@Downloads
downloadToDIR=~/Downloads

pushd "$downloadToDIR" >/dev/null

ECHO "Google Chrome"
source "$downloadsDIR/google-chrome.sh"

ECHO "Sublime Text"
source "$downloadsDIR/sublime-text.sh"

popd >/dev/null

echo
echo -e "\033[0;37m download to \033[0;33m~/Downloads\033[0m"
echo
echo -e "\033[0;7m all done. \033[0m"
echo
