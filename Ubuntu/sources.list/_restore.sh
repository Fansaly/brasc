#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

fSrc=$currentDIR/sources.list
fSys=/etc/apt/sources.list

md5Src=$(md5sum "${fSrc}" | awk '{print $1}')
md5Sys=$(md5sum "${fSys}" | awk '{print $1}')

if test "$md5Sys" != "$md5Src" && sudo -v; then
  sudo cp ${fSys} ${fSys}.$(date "+%Y-%m-%d_%H-%M-%S")
  sudo cp ${fSrc} ${fSys}
fi
