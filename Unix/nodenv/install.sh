#!/bin/bash
#
# install nodenv

if [[ -n $(command -v nodenv) || -d "$HOME/.nodenv" ]]; then
  return 1 &>/dev/null || exit 1
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
  profile=~/.bash_profile
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  profile=~/.profile
fi
nodenv=~/.nodenv

command -v git &>/dev/null || {
  echo -e "\033[0;35mgit\033[0m is not installed."
  return 1 &>/dev/null || exit 1
}

git clone https://github.com/nodenv/nodenv.git "$nodenv" && {
  cat "$profile" | grep "nodenv" >/dev/null 2>&1 || {
    echo -e "\n# nodenv environment" >> "$profile"
    echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> "$profile"
    echo 'eval "$(nodenv init -)"' >> "$profile"
  }

  mkdir -p "$nodenv/plugins"
  git clone https://github.com/nodenv/node-build.git "$nodenv/plugins/node-build"
  git clone https://github.com/nodenv/nodenv-update.git "$nodenv/plugins/nodenv-update"

  chmod -R go-w "$nodenv"

  return 5 &>/dev/null || exit 5
}
