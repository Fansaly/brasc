#!/bin/bash

xcode-select -p >/dev/null 2>&1 || {
  echo -e "\033[0;91mplease install \033[0;95mxcode command line tools\033[0m"
  xcode-select --install
  return 1 &>/dev/null || exit 1
}
