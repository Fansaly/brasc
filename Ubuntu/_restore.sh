#!/bin/bash

function ECHO() {
  echo -e "\033[0;36m$1\033[0m $2 \033[0;37m... \033[0m"
}

masterDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
unixDIR=$masterDIR/../Unix
unset RESTART_SHELL


ECHO "config" "sources list"
source "$masterDIR/sources.list/_restore.sh"

ECHO "install" "packages (apt-get)"
source "$masterDIR/packages/install.sh"

ECHO "setting" "locale"
source "$masterDIR/locale/_restore.sh"


ECHO "install" "oh-my-zsh"
source "$unixDIR/oh-my-zsh/install.sh"
OhMyZshCode=$?

ECHO "install" "homebrew and packages"
source "$unixDIR/homebrew/install.sh"
[[ $? -eq 5 ]] && RESTART_SHELL=true

# ECHO "install" "nodenv (nvm)"
# source "$unixDIR/nodenv/install.sh"
# [[ $? -eq 5 ]] && RESTART_SHELL=true


ECHO "create" "some profile"
source "$unixDIR/_create/_create.sh"

ECHO "config" "profile"
source "$unixDIR/profile/_restore.sh"

ECHO "config" "vim"
source "$unixDIR/vim/_restore.sh"

ECHO "config" "git"
source "$unixDIR/git/_restore.sh"

ECHO "config" "ssh key"
source "$unixDIR/ssh/_restore.sh"


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
