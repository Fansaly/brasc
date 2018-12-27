#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cp "${currentDIR}/.vimrc" ~/
chmod 644 ~/.vimrc
