#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

source "$currentDIR/install-homebrew.sh"
_CODE_=$?
source "$currentDIR/install-packages.sh"

return $_CODE_ &>/dev/null || exit $_CODE_
