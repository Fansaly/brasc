#!/bin/bash

ZSH=~/.oh-my-zsh
zshrc=~/.zshrc
unset installed
unset changed

command -v git &>/dev/null || {
  echo -e "\033[0;35mgit\033[0m is not installed."
  return 1 &>/dev/null || exit 1
}

# install oh-my-zsh
if [[ ! -d "$ZSH" ]]; then
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    return 1 &>/dev/null || exit 1
  }

  chmod -R go-w "$ZSH"
  cp "$ZSH/templates/zshrc.zsh-template" "$zshrc"

  # switch to zsh
  CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
  if [[ "$CURRENT_SHELL" != "zsh" && -n $(command -v chsh) ]]; then
    chsh -s $(grep /zsh$ /etc/shells | tail -1)
  fi

  installed=true
fi


if [[ ! -f "$zshrc" ]]; then
  echo "~/\033[0;33m.zshrc \033[0;31mdoesn't exists.\033[0m"
  return 1 &>/dev/null || exit 1
fi

content=$(cat "$zshrc")
# config oh-my-zsh theme
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  ZSH_THEME_Target=ZSH_THEME=\"maran\"
  ZSH_THEME_Current=$(printf "$content" | grep -e "^ZSH_THEME=*")

  if [[ "$ZSH_THEME_Current" != "$ZSH_THEME_Target" ]]; then
    changed=true
    content=$(printf "$content" | sed -e 's/'"${ZSH_THEME_Current}"'/'"${ZSH_THEME_Target}"'/')
  fi
fi
# source profile into zsh
printf "$content" | grep -e "source ~/.*profile" >/dev/null 2>&1 || {
  changed=true

  if [[ "$OSTYPE" == "darwin"* ]]; then
    content+="\n\nsource ~/.bash_profile\n"
  elif [[ "$OSTYPE" == "linux-gnu" ]]; then
    content+="\n\nsource ~/.profile\n"
  fi
}
# save config to zshrc
[[ -n $changed ]] && printf "$content" > "$zshrc"


# exit code
if [[ -n $installed && -n $changed ]]; then
  code=9
elif [[ -n $installed ]]; then
  code=7
elif [[ -n $changed ]]; then
  code=5
else
  code=0
fi

return $code &>/dev/null || exit $code
