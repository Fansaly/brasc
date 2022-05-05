#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config_dir="$currentDIR/config"
sublime_dir="$HOME/Library/Application Support/Sublime Text"

# Sublime project config file
cp "$sublime_dir/"*.sublime-project "$config_dir"


if [[ ! -d "$sublime_dir/Packages/User" ]]; then
  return 0 &>/dev/null || exit 0
fi

# Preferences, Key Bindings, Settings, etc
find "$sublime_dir/Packages/User" \
  -depth 1 \
  -type f \
  \( \
    -name "*.sublime-settings" -o \
    -name "*.sublime-keymap" -o \
    -name "*.sublime-build" \
  \) \
  -exec cp {} "$config_dir/Packages/User" \;
