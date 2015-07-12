#!/bin/bash

DIST=~/.prax-app
if [ -e ~/.prax-app ]; then
  echo "already installed : prax" 1>&2
  exit 1
fi

git clone git://github.com/ysbaddaden/prax.git ${DIST}

cd ${DIST}
# ./bin/prax install
cd ext
make
sudo make install


cat <<'EOM'
If you want to use plax command, you shold write following text in your .bashrc or .zshrc.

---------------------------------
export PATH=$PATH:~/.prax-app/bin
---------------------------------

