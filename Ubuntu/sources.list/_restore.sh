#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

sources_template=$currentDIR/sources.list.template
sources_system=/etc/apt/sources.list
sources_temp=/tmp/sources.list
codename=$(lsb_release -sc)

cat "$sources_template" | sed -E 's/CODENAME/'$codename'/' > "$sources_temp"

md5_system=$(md5sum "$sources_system" | awk '{print $1}')
md5_temp=$(md5sum "$sources_temp" | awk '{print $1}')

if test "$md5_system" != "$md5_temp" && sudo -v; then
  sudo cp "$sources_system" "$sources_system.$(date "+%Y-%m-%d_%H-%M-%S")"
  sudo mv "$sources_temp" "$sources_system"
fi
