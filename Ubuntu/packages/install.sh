#!/bin/bash

packages=(
  # compile packages, e.g.:
  # some packages from homebrew
  "gcc"
  "zip"
  "unzip"
  "tree"
  "zsh"
)

todo=()

for package in ${packages[@]}; do
  result=$(dpkg-query -W -f='${Package}: ${Status} ${Version}' $package)
  code=$?

  if [[ "$result" =~ "not-installed" || $code -ne 0 ]]; then
    todo+=("$package")
  fi
done

if test ${#todo[@]} -gt 0 && sudo -v; then
  echo -e "\033[0;36mupdating\033[0m: packages list ..."
  sudo apt-get update
  # echo -e "\033[0;36mupgrading\033[0m: packages ..."
  # sudo apt-get -y upgrade
  echo -e "\033[0;36minstalling\033[0m: \033[0;95m${todo[@]}\033[0m ..."
  sudo apt-get -y install ${todo[@]}
fi
