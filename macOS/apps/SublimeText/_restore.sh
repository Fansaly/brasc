#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
config_dir="$currentDIR/config"

sublime_dir="$HOME/Library/Application Support/Sublime Text 3"
installed_packages_dir="$sublime_dir/Installed Packages"

if [[ ! -d "$installed_packages_dir" ]]; then
  mkdir -p "$installed_packages_dir"
fi

# Preferences, Key Bindings, Settings, etc
cp -r "$config_dir/"* "$sublime_dir/"

# Package Control
package_control_file="Package Control.sublime-package"

if [[ -f "$installed_packages_dir/$package_control_file" ]]; then
  return 0 &>/dev/null || exit 0
fi

package_control_url="https://packagecontrol.io/Package Control.sublime-package"
proxy_server=socks5://127.0.0.1:1080

curl -x $proxy_server -kfsIL "$package_control_url" >/dev/null

if [[ $? -ne 0 ]]; then
  echo -e "\033[0;31mFailed connect to Package Control server.\033[0m"
else
  tmp_file="/var/tmp/$package_control_file"

  curl -x $proxy_server -kfsSL "$package_control_url" -o "$tmp_file"

  if [[ $? -ne 0 ]]; then
    echo -e "\033[0;31mFailed download the 'Package Control' file.\033[0m"
  else
    mv "$tmp_file" "$installed_packages_dir"
  fi
fi
