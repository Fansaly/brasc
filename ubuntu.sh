#!/bin/bash

if [[ "$OSTYPE" != "linux-gnu" ]]; then
  echo -e "\033[0;33mOnly for GNU/Linux system.\033[0m\n"
  exit 1
fi

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$DIR/Ubuntu/_restore.sh"
