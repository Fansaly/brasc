#!/bin/bash

packages=(
  # compile packages, e.g.:
  # some packages from homebrew
  "gcc"
  "unzip"
  "tree"
  "zsh"
)

todo=()

for package in ${packages[@]}; do
  dpkg-query -W -f='${Package}: ${Status} ${Version}' $package &>/dev/null

  if [[ $? -ne 0 ]]; then
    todo+=("$package")
  fi
done

if test ${#todo[@]} -gt 0 && sudo -v; then
  echo -e "\033[0;32mupdating\033[0m: packages list ..."
  sudo apt-get update
  # echo -e "\033[0;32mupgrading\033[0m: packages ..."
  # sudo apt-get -y upgrade
  echo -e "\033[0;35minstalling\033[0m: \033[0;4m${todo[@]}\033[0m ..."
  sudo apt-get -y install ${todo[@]}
fi
