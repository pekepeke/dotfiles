#!/bin/bash

caveats() {
  cat <<EOM
## Debian or Ubuntu

sudo apt-get install build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev

## Fedora

sudo yum groupinstall 'Development Tools' && sudo yum install curl git m4 ruby texinfo bzip2-devel curl-devel expat-devel ncurses-devel zlib-devel
EOM
}

if ! ruby -e "$(curl -L https://raw.github.com/Homebrew/linuxbrew/go/install)"; then
  caveats
fi

