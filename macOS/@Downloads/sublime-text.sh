#!/bin/bash

rex='.*href\s*=\s*"(.*(sublime_text_build_(\w*)_mac\.zip))">.*'

ctx=$(curl -fsSL "https://www.sublimetext.com/download")
ctx=$(echo "$ctx" | grep -m 1 -i "$(echo "$rex" | sed -e 's/[()]//g')")

url=$(echo "$ctx" | perl -pe "s/${rex}/\1/i")
version=$(echo "$ctx" | perl -pe "s/${rex}/\3/i")
output_file=$(echo "$ctx" | perl -pe "s/${rex}/\2/i")

curl -fSL "$url" -o "$output_file"
