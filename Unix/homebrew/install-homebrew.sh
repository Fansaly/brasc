#!/bin/bash

brew -v >/dev/null 2>&1 && {
  return 0 &>/dev/null || exit 0
}


# install homebrew for macOS and Linux
function install_homebrew() {
  local code=5

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  if [[ $? -ne 0 ]]; then
    code=1
  elif [[ -f "$PREFIX_BREW/bin/brew" ]]; then
    # make brew available on linux
    eval "$($PREFIX_BREW/bin/brew shellenv)"
  fi

  return $code
}

install_homebrew
