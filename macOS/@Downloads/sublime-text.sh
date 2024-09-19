#!/bin/bash

# https://formulae.brew.sh/cask/sublime-text
ctx=$(curl -fsSL "https://formulae.brew.sh/api/cask/sublime-text.json" | xargs | sed 's/ //g')

rex='[\s\S]*(https:.*?_mac\.zip)[\s\S]*'
url=$(echo "$ctx" | perl -pe "s/${rex}/\1/i")

if [[ ! "$url" =~ ^http.*mac\.zip$ ]]; then
  echo -e "\033[0;31minvalid url.\033[0m"
else
  output_file=$(echo "$url" | perl -pe "s/.*?([^\/]+\.zip)/\1/i")
  curl -fSL "$url" -o "$output_file"
fi
