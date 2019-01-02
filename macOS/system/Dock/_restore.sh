#!/bin/bash
#
# Dock

_currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source "$_currentDIR/_dock_settings.sh" $1
source "$_currentDIR/_dock_persistent.sh" $1

if [[ "$1" != "--norestart" ]]; then
  killall Dock
fi
