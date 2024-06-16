#!/bin/bash

if ! which mise >/dev/null 2>&1 ; then
  curl https://mise.run | sh
  eval "$(mise activate $(basename $SHELL))"
else
  mise self-update
fi
mise install deno
mise plugin install vim -y
mise plugin install neovim -y
mise plugin install perl -y
mise plugin install php -y
mise plugin install mysql -y
mise use deno


