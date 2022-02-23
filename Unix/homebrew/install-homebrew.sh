#!/bin/bash

if [[ -n $(command -v brew) ]]; then
  return 0 &>/dev/null || exit 0
fi


# install homebrew for macOS and Linux
function install_homebrew() {
  local code=5

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  if [[ $? -ne 0 ]]; then
    code=1
  fi

  return $code
}

install_homebrew
