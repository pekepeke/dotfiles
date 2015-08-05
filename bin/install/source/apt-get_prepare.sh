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

add_chrome_repository() {
  sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
}

apt_keys() {
  cat <<EOM
EOM
}

for p in $(repositories); do
  sudo add-apt-repository -y $p
done
add_chrome_repository

for url in $(apt_keys); do
  curl -L ${url} | sudo apt-key add -
done
sudo apt-get update
