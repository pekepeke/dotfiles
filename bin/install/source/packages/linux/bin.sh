#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  TEMP=/tmp/
  AUTHOR=marcosnils
  PG=bin
  INSTALL_DIR=~/.local/bin
  ARCH=`uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/'`

  curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest > $TEMP/$PG.json
  CDIR=`pwd`

  DL_URL="$(cat $TEMP/$PG.json \
| grep "browser_download_url.*linux_$ARCH" \
| cut -d : -f 2,3 \
| tr -d \")"

  cd $TEMP
  echo curl -Lo $PG $DL_URL
  curl -Lo $PG $DL_URL
  chmod +x $TEMP/$PG
  mv $TEMP/$PG $INSTALL_DIR/$PG

  rm -f $TEMP/$PG.json
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

