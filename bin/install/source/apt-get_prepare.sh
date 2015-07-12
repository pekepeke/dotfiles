#!/bin/bash

repositories() {

  cat <<EOM
ppa:japaneseteam/ppa
ppa:mutate/ppa
ppa:zeal-developers/ppa
ppa:noobslab/themes
ppa:webupd8team/java
ppa:neovim-ppa/unstable
mod_pagespeed_beacon
EOM
# ppa:nilarimogard/webupd8 # for albert
}

apt_keys() {
  cat <<EOM
EOM
}

for p in $(repositories); do
  sudo add-apt-repository -y $p
done

for url in $(apt_keys); do
  curl -L ${url} | sudo apt-key add -
done
sudo apt-get update
