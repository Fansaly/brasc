#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [[ "$OSTYPE" == "darwin"* ]]; then
  fileDIR="$currentDIR/../../macOS/system/profile"
  profile=~/.bash_profile
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  fileDIR="$currentDIR/../../Ubuntu/profile"
  profile=~/.profile
fi

if [[ ! -f "${fileDIR}/._profile_" ]]; then
  return 0 &>/dev/null || exit 0
fi

cp "${fileDIR}/._profile_" ~/
chmod 644 ~/._profile_
source ~/._profile_

cat "$profile" | grep "source ~/._profile_" >/dev/null 2>&1 || {
  echo -e "\nsource ~/._profile_" >> "$profile"
}
