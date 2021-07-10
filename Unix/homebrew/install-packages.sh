#!/bin/bash

# uninstalled packages
# ----------------------------------------------------
# passing multiple distinct arrays to a shell function
# https://stackoverflow.com/questions/10953833
function uninstalled() {
  declare -i num_args array_num
  declare -a curr_args
  unset a b

  while (( $# )) ; do
    curr_args=( )
    num_args=$1; shift

    while (( num_args-- > 0 )) ; do
      curr_args+=( "$1" ); shift
    done

    case $((++array_num)) in
      1)
        a+=("${curr_args[@]}")
      ;;
      2)
        b+=("${curr_args[@]}")
      ;;
    esac
  done

  todo=()
  packages=("${a[@]}")
  installed=("${b[@]}")

  if [[ ${#installed[@]} -eq 0 ]]; then
    todo=$packages
  else
    for package in ${packages[@]}; do
      if [[ ! " ${installed[@]} " =~ " $package " ]]; then
        todo+=("$package")
      fi
    done
  fi

  echo "${todo[@]}"
}

function install_packages() {
  brew=$1
  listDIR=$2

  if [[ -n $(command -v brew) ]]; then
    brew=$(command -v brew)
  fi

  if [[ ! -f "$brew" ]]; then
    echo -e "\033[0;35mbrew\033[0m is not installed."
    return 1
  fi

  # get homebrew packages list files
  HBlist=($(find "$listDIR" -type f \( -name "homebrew.list" -o -name "homebrew.cask.list" \)))

  for list in "${HBlist[@]}"; do
    # cask packages only for macOS
    if [[ "$(basename $list)" == "homebrew.cask.list" && "$OSTYPE" != "darwin"* ]]; then
      continue
    fi

    packages=($(cat "$list" | sed -e "/^#/d"))
    if [[ "$(basename $list)" == "homebrew.list" ]]; then
      installed=($("$brew" list))
    else
      installed=($("$brew" list --cask))
    fi

    [[ ${#packages[@]} -eq 0 ]] && packages=("")
    [[ ${#installed[@]} -eq 0 ]] && installed=("")

    # to install packages
    todo=($(
      uninstalled \
        "${#packages[@]}" "${packages[@]}" \
        "${#installed[@]}" "${installed[@]}"
    ))

    i_i=0
    # install
    for package in ${todo[@]}; do
      echo -n "[$((++i_i))/${#todo[@]}] "
      echo -e "\033[0;36minstalling\033[0m \033[0;95m${package}\033[0m ..."

      if [[ "$(basename $list)" == "homebrew.list" ]]; then
        "$brew" install $package
      else
        "$brew" install --cask $package
      fi
    done
  done
}

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [[ "$OSTYPE" == "darwin"* ]]; then
  brew=/usr/local/bin/brew
  listDIR="$currentDIR/../../macOS/apps/homebrew"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  brew=/home/linuxbrew/.linuxbrew/bin/brew
  listDIR="$currentDIR/../../Ubuntu/homebrew"
fi

install_packages "$brew" "$listDIR"
