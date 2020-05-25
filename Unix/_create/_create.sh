#!/bin/bash

function create_profile() {
  local profile="$1"

  if [[ ! -f "$profile" ]]; then
    touch "$profile"
  fi
}

create_profile "$HOME/.hushlogin"

if [[ "$OSTYPE" == "darwin"* ]]; then
  create_profile "$HOME/.bash_profile"
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  create_profile "$HOME/.profile"
fi
