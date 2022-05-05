#!/bin/bash

# https://www.google.com/chrome
url=https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
output_file=googlechrome.dmg

curl -fSL "$url" -o "$output_file"
