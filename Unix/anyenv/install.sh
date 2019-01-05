#!/bin/bash
#
# install anyenv and ndenv

if [[ -n $(command -v anyenv) || -d "$HOME/.anyenv" ]]; then
  return 0 &>/dev/null || exit 0
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
  profile=~/.bash_profile
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  profile=~/.profile
fi
anyenv=~/.anyenv

command -v git &>/dev/null || {
  echo -e "\033[0;35mgit\033[0m is not installed."
  return 1 &>/dev/null || exit 1
}

git clone https://github.com/riywo/anyenv.git "$anyenv" && {
  cat "$profile" | grep "anyenv" >/dev/null 2>&1 || {
    echo -e "\n# anyenv environment" >> "$profile"
    echo 'export PATH="$HOME/.anyenv/bin:$PATH"' >> "$profile"
    echo 'eval "$(anyenv init -)"' >> "$profile"
  }

  mkdir -p "$anyenv/plugins"
  git clone https://github.com/znz/anyenv-update.git "$anyenv/plugins/anyenv-update"

  "$anyenv/bin/anyenv" install ndenv

  chmod -R go-w "$anyenv"

  return 5 &>/dev/null || exit 5
}
