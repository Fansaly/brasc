#!/bin/bash

# https://www.google.com/chrome
# https://formulae.brew.sh/cask/google-chrome
# /api/cask/google-chrome.json (JSON API)
url=https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
output_file=googlechrome.dmg

curl -fSL "$url" -o "$output_file"
