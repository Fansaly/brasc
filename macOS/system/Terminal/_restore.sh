#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
terminal=$currentDIR/terminal.terminal

domain=com.apple.Terminal
prefDIR=~/Library/Preferences
plist=$prefDIR/$domain.plist

preferences=$(cat "$terminal")
name=$(echo "$preferences" | plutil -extract "name" xml1 -o - - | plutil -p - | sed -e 's/"//g')

plutil -remove "Window Settings.$name" "$plist" &>/dev/null
plutil -insert "Window Settings.$name" -xml "$preferences" "$plist"

defaults write $domain "Default Window Settings" "$name"
defaults write $domain "Startup Window Settings" "$name"
