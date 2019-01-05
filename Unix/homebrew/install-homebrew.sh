#!/bin/bash

if [[ -n $(command -v brew) ]]; then
  return 0 &>/dev/null || exit 0
fi


function install_macos_homebrew() {
  # install homebrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  # config homebrew environment
  profile=~/.bash_profile
  cat "$profile" | grep "homebrew" >/dev/null 2>&1 || {
    echo -e "\n# homebrew environment" >> "$profile"
    echo "export HOMEBREW_BOTTLE_DOMAIN=\"${HOMEBREW_BOTTLE_DOMAIN}\"" >> "$profile"
  }

  return 5
}

function install_linux_homebrew() {
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    return 1
  fi

  # install homebrew
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  # config homebrew environment
  profile=~/.profile
  cat "$profile" | grep "linuxbrew" >/dev/null 2>&1 || {
    echo -e "\n# homebrew environment" >> "$profile"
    echo "eval \$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> "$profile"
    echo "export HOMEBREW_BOTTLE_DOMAIN=\"${HOMEBREW_BOTTLE_DOMAIN}\"" >> "$profile"
  }

  return 5
}

HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
if [[ "$OSTYPE" == "darwin"* ]]; then
  install_macos_homebrew
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  install_linux_homebrew
fi
