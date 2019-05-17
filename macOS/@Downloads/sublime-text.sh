#!/bin/bash

rex='.*<a\s*href\s*=\s*"(.*(Sublime\s*Text\s*Build\s*(\d*)\.dmg))">.*'

ctx=$(curl -fsSL "https://www.sublimetext.com")
ctx=$(echo "${ctx}" | grep -m 1 -i "$(echo "${rex}" | sed -e 's/[()]//g')")

url=$(echo "${ctx}" | perl -pe "s/${rex}/\1/i")
version=$(echo "${ctx}" | perl -pe "s/${rex}/\3/i")
output_file=$(echo "${ctx}" | perl -pe "s/${rex}/\2/i")

curl -fSL "$url" -o "${output_file}"
