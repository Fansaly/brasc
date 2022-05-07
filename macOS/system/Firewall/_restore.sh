#!/bin/bash

sfw=/usr/libexec/ApplicationFirewall/socketfilterfw
re=".*State[[:space:]]*=[[:space:]]*\(.*\))"

state=$($sfw --getglobalstate | sed -e "s/$re/\1/")

if [[ $state -ne 1 ]]; then
  sudo $sfw --setglobalstate on &>/dev/null
fi
