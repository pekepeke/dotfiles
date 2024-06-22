#!/bin/bash


# {{{1
if [ ! -e ~/.dropbox-dist ]; then
  # cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.$(uname -i)" | tar xzf -
  # ~/.dropbox-dist/dropboxd &
  # [ ! -e ~/bin ] && mkdir ~/bin
  if [ ! -e ~/dropbox.py ]; then
    wget -O ~/dropbox.py "http://www.dropbox.com/download?dl=packages/dropbox.py"
    chmod +x ~/dropbox.py
  fi
  ~/dropbox.py start
  ~/dropbox.py autostart
fi

repositories() {

  cat <<EOM
ppa:japaneseteam/ppa
ppa:indicator-multiload/stable-daily
ppa:vincent-c/nevernote
ppa:mizuno-as/silversearcher-ag
ppa:noobslab/apps
ppa:mizuno-as/silversearcher-ag
ppa:noobslab/themes
ppa:tualatrix/ppa
ppa:n-muench/calibre
ppa:canonical-qt5-edgers/qt5-proper
ppa:jerzy-kozera/zeal-ppa
ppa:damnvid/ppa
ppa:stebbins/handbrake-releases
ppa:mitya57
ppa:ubuntu-on-rails/ppa
EOM
# ppa:bikooo/glippy
# ppa:cassou/emacs
# ppa:webupd8team/atom
}

apt_keys() {
  cat <<EOM
http://apt.mucommander.com/apt.key
EOM
}

for p in $(repositories); do
  sudo add-apt-repository -y $p
done
if [ ! -e /etc/apt/sources.list.d/mucommander.list ]; then
  echo deb http://apt.mucommander.com stable main non-free contrib | sudo tee /etc/apt/sources.list.d/mucommander.list >/dev/null
fi

for url in $(apt_keys); do
  curl -L ${url} | sudo apt-key add -
done
sudo apt-get update

