#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  cd /var/tmp
  local BINDIR=~/.local/bin
  if [ -e mergepbx ]; then
    cd mergepbx
    git reset --hard HEAD
    git pull
    ./build.py
    [ ! -e ~$BINDIR/ ] && mkdir -p ~$BINDIR/
    cp mergepbx ~$BINDIR/
  else
    git clone https://github.com/simonwagner/mergepbx.git
    cd mergepbx
    ./build.py
    [ ! -e ~$BINDIR/ ] && mkdir -p ~$BINDIR/
    cp mergepbx ~$BINDIR/
  fi

  # local url="$(curl https://api.github.com/repos/simonwagner/mergepbx/releases | jq -r '.[0].assets[0].browser_download_url')"
  # if [ -n "$url" ]; then
  #   curl -Lo /tmp/mergepbx "$url"
  #   [ -e ~$BINDIR/mergepbx ] && mv ~$BINDIR/mergepbx /tmp/mergepbx-$(date +'%s')
  #   mv /tmp/mergepbx ~$BINDIR/
  # fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvs:" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    s)
      #$OPTARG
      ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

