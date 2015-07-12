#!/bin/bash

packages() {
  cat <<EOM
github.com/peco/peco/cmd/peco
github.com/peco/migemogrep
github.com/jingweno/gh
github.comstedolan/jq
github.com/motemen/ghq
EOM
}

for package in $(packages); do
  name=$(basename $package)
  which $package >/dev/null 2>&1 || go get -u $package
done

