#!/bin/bash

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo -e "\033[0;33mOnly for macOS system.\033[0m\n"
  exit 1
fi

function help() {
  echo
  echo "    -b <name>   Backup current macOS and apps configuration."
  echo "                name is \`empty' execute common operations,"
  echo "                name is all execute all operations,"
  echo "                otherwise, execute operations related to name."
  echo "    -r <name>   Restore macOS and apps configuration to current."
  echo "                same above."
  echo "    -d          Download some applications from internet."
  echo
  echo "    usage: ./$(basename $0) [-b | -r | -d]"
  echo
}

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

while getopts brd opt; do
  case $opt in
    b)
      source "$DIR/macOS/_backup.sh" "${@//-$opt/}"
      exit $?
    ;;
    r)
      source "$DIR/macOS/_restore.sh" "${@//-$opt/}"
      exit $?
    ;;
    d)
      source "$DIR/macOS/_download.sh"
      exit $?
    ;;
    ?)
      help
      exit 0
    ;;
  esac
done

help
