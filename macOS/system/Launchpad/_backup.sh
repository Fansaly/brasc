#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dbBackup=$currentDIR/db
dbTarget="$(find /private/var/folders -user $(id -u) -name com.apple.dock.launchpad 2>/dev/null)/db"

if [[ -d "$dbTarget" ]]; then
  rm -rf "$dbBackup"
  cp -a "$dbTarget" "$dbBackup"
fi
