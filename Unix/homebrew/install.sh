#!/bin/bash

if [[ -n $(command -v brew) ]]; then
  return 1 &>/dev/null || exit 1
fi


# https://stackoverflow.com/questions/10953833/passing-multiple-distinct-arrays-to-a-shell-function
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

function install_macos() {
  echo "install macos brew"
}

function install_linux() {
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    return 1
  fi

  # install linux homebrew
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  if [[ $? -ne 0 ]]; then
    return 1
  fi

  brew=/home/linuxbrew/.linuxbrew/bin/brew
  profile=~/.profile

  # config linux homebrew environment
  cat "$profile" | grep "linuxbrew" >/dev/null 2>&1 || {
    echo -e "\n# homebrew environment" >> "$profile"
    echo "eval \$($brew shellenv)" >> "$profile"
    echo "export HOMEBREW_BOTTLE_DOMAIN=\"https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles\"" >> "$profile"
  }

  # install linux homebrew packages
  packages=(
    "yarn"
  )
  installed=($($brew list))
  [[ ${#installed[@]} -eq 0 ]] && installed=("")

  todo=($(
    uninstalled \
      "${#packages[@]}" "${packages[@]}" \
      "${#installed[@]}" "${installed[@]}"
  ))

  for package in ${todo[@]}; do
    echo -n "[$((++i_i))/${#todo[@]}] "
    echo -e "\033[0;35minstalling\033[0m: \033[0;4m${package}\033[0m ..."
    $brew install $package
  done

  # exit code
  return 5
}


if [[ "$OSTYPE" == "darwin"* ]]; then
  install_macos
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  install_linux
fi
