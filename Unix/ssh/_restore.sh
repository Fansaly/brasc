#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [[ "$OSTYPE" == "darwin"* ]]; then
  sshDIR="$currentDIR/../../macOS/.ssh"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  sshDIR="$currentDIR/../../Ubuntu/.ssh"
fi

if [[ ! -f "${sshDIR}/id_rsa" ]]; then
  return 1 &>/dev/null || exit 1
fi

cp -r "${sshDIR}" ~/
chmod 755 ~/.ssh
chmod 600 ~/.ssh/id_rsa*
chmod 644 ~/.ssh/known_hosts >/dev/null 2>&1
