#!/bin/bash

function ECHO() {
  echo -e "\033[0;36m$1\033[0m $2 \033[0;37m... \033[0m"
}

masterDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
systemDIR=$masterDIR/system
appsDIR=$masterDIR/apps
unixDIR=$masterDIR/../Unix
unset RESTART_SHELL


source "$masterDIR/_check_xcode.sh"
[[ $? -ne 0 ]] && {
  return 1 &>/dev/null || exit 1
}


FLAG=$@
F_COMMON=true
F_LAUNCHPAD=false

if [[ $FLAG == "all" || $FLAG == "launchpad" ]]; then
  F_LAUNCHPAD=true
fi
if [[ $FLAG == "launchpad" ]]; then
  F_COMMON=false
fi


if [[ $F_COMMON == "true" ]]; then
  ECHO "create" "some profile"
  source "$unixDIR/_create/_create.sh"

  ECHO "config" "profile"
  source "$unixDIR/profile/_restore.sh"

  echo

  ECHO "config" "vim"
  source "$unixDIR/vim/_restore.sh"

  ECHO "config" "git"
  source "$unixDIR/git/_restore.sh"

  ECHO "config" "ssh key"
  source "$unixDIR/ssh/_restore.sh"

  echo

  ECHO "setting" "Terminal"
  source "$systemDIR/Terminal/_restore.sh"

  ECHO "setting" "Clock display style"
  source "$systemDIR/Clock/_restore.sh" --norestart

  ECHO "setting" "System menu extras"
  source "$systemDIR/SysMenuExtras/_restore.sh" --norestart

  killall SystemUIServer

  ECHO "setting" "Dock, Dashboard and Hot Corners"
  source "$systemDIR/Dock/_restore.sh" --norestart

  killall Dock

  ECHO "setting" "Finder"
  source "$systemDIR/Finder/_restore.sh"
fi

if [[ $F_LAUNCHPAD == "true" ]]; then
  ECHO "restore" "Launchpad"
  source "$systemDIR/Launchpad/_restore.sh"
fi

echo

if [[ $F_COMMON == "true" ]]; then
  ECHO "install" "oh-my-zsh"
  source "$unixDIR/oh-my-zsh/install.sh"
  OhMyZshCode=$?

  ECHO "install" "homebrew and packages"
  source "$unixDIR/homebrew/install.sh"
  [[ $? -eq 5 ]] && RESTART_SHELL=true

  # ECHO "install" "nodenv (nvm)"
  # source "$unixDIR/nodenv/install.sh"
  # [[ $? -eq 5 ]] && RESTART_SHELL=true


  ECHO "config" "Sublime Text"
  source "$appsDIR/SublimeText/_restore.sh"
fi


echo
echo -e "\033[0;7m all done. \033[0m"
echo

if [[ -n $RESTART_SHELL || $OhMyZshCode -ge 5 ]]; then
  exec $SHELL -l
fi

# if [[ -n $RESTART_SHELL ]]; then
#   if [[ $OhMyZshCode -eq 9 || $OhMyZshCode -eq 7 ]]; then
#     exec $SHELL -l <<-EOF
#     env zsh -l
# EOF
#   else
#     exec $SHELL -l
#   fi
# else
#   if [[ $OhMyZshCode -eq 9 ]]; then
#     exec $SHELL -l <<-EOF
#     env zsh -l
# EOF
#   elif [[ $OhMyZshCode -eq 7 ]]; then
#     env zsh -l
#   elif [[ $OhMyZshCode -eq 5 ]]; then
#     exec $SHELL -l
#   fi
# fi
