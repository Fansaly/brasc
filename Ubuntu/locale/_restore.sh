#!/bin/bash

langs=(
  "zh_CN.UTF-8"
)

for lang in ${langs[@]}; do
  lang_locale="${lang/UTF-8/utf8}"

  locale -a | grep "$lang_locale" >/dev/null 2>&1 || {
    sudo locale-gen $lang
  }
done
