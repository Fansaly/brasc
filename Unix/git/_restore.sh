#!/bin/bash

currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

cp "${currentDIR}/.gitconfig" ~/
chmod 644 ~/.gitconfig
