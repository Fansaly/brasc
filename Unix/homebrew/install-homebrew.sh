#!/bin/bash

if [[ -n $(command -v brew) ]]; then
  return 0 &>/dev/null || exit 0
fi


function isLinux() {
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "os: linux"
  fi
}

function config_homebrew_environment() {
  if [[ -z "$(isLinux)" ]]; then
    return 0
  fi

  # config homebrew environment
  profile=~/.profile
  cat "$profile" | grep "linuxbrew" >/dev/null 2>&1 || {
    echo -e "\n# homebrew environment" >> "$profile"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> "$profile"
  }
}

# install homebrew for macOS and Linux
function install_homebrew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  if [[ $? -ne 0 ]]; then return 1; fi

  config_homebrew_environment
  return 5
}

install_homebrew
