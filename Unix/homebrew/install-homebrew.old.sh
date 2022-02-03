#!/bin/bash

if [[ -n $(command -v brew) ]]; then
  return 0 &>/dev/null || exit 0
fi


function isLinux() {
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "os: linux"
  fi
}

function unarchive() {
  local input_file="$1"
  local output_dir="$2"

  if [[ ! -f "$input_file" || ! -d "$output_dir" ]]; then
    return 1
  fi

  tar xz -f "$input_file" --strip 1 -C "$output_dir"
}

function download_package() {
  local author="$1"
  local package="$2"
  local output_dir="$3"
  local output_file="$4"

  if [[ -z "$author" || -z "$package" ]]; then
    return 1
  fi

  if [[ -z "$output_file" ]]; then
    output_file="${package}.tar.gz"

    if [[ -n "$output_dir" ]]; then
      output_file="${output_dir}/${output_file}"
    fi
  fi

  mkdir -p "$output_dir" 2>/dev/null

  local github_url="https://github.com/${author}/${package}"

  echo -e "Downloading $package from $github_url ..."

  curl -o "$output_file" -fSL "${github_url}/tarball/master"
  if [[ $? -ne 0 ]]; then return $?; fi

  PACKAGE_FILE="$output_file"
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

function install_linuxbrew_manually() {
  local author="Homebrew"
  local homebrew_prefix="/home/linuxbrew/.linuxbrew"
  local homebrew_main="${homebrew_prefix}/Homebrew"
  local homebrew_brew="brew"
  local homebrew_core="linuxbrew-core"
  local homebrew_brew_dir="$homebrew_main"
  local homebrew_core_dir="$homebrew_main/Library/Taps/homebrew/homebrew-core"
  local PACKAGE_FILE

  if ! sudo -v; then return 1; fi

  GROUP="$(id -gn)"

  sudo mkdir -p "$homebrew_core_dir"
  sudo chown -R "$USER:$GROUP" "$homebrew_prefix"
  sudo chmod -R 755 "$homebrew_prefix"

  download_package "$author" "$homebrew_brew" "/var/tmp"
  if [[ $? -ne 0 ]]; then return 1; fi

  unarchive "$PACKAGE_FILE" "$homebrew_brew_dir"

  mkdir -p "${homebrew_prefix}/bin"
  ln -sf "${homebrew_main}/bin/brew" "${homebrew_prefix}/bin/brew"

  download_package "$author" "$homebrew_core" "/var/tmp"
  if [[ $? -ne 0 ]]; then return 1; fi

  unarchive "$PACKAGE_FILE" "$homebrew_core_dir"

  config_homebrew_environment
  return 5
}

# install homebrew for macOS and Linux
function install_homebrew() {
  local author="Homebrew"
  local package="install"
  local PACKAGE_FILE

  download_package "$author" "$package" "/var/tmp"
  if [[ $? -ne 0 ]]; then return 1; fi

  local outpt_dir="/var/tmp/$package"
  mkdir -p "$outpt_dir"
  unarchive "$PACKAGE_FILE" "$outpt_dir"

  /bin/bash "$outpt_dir/install.sh"
  if [[ $? -ne 0 ]]; then return 1; fi

  config_homebrew_environment
  return 5
}

if [[ -n "$(isLinux)" ]]; then
  install_linuxbrew_manually
else
  install_homebrew
fi
