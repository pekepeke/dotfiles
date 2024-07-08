#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  AUTHOR=dandavison
  PG=delta
  INSTALL_DIR=~/.local/bin
  if [ -e "$INSTALL_DIR/$PG" ]; then
    echo "already installed: $INSTALL_DIR/$PG"
    return 0
  fi
  DL_URL="$(curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest \
| grep "browser_download_url.*`uname -m`.*linux-musl" \
| cut -d : -f 2,3 \
| tr -d \")"
  if [ "$DL_URL" = "" ]; then
    echo "url not found" 1>&2
    return 1
  fi
  curl -LO $DL_URL
  tar xvf $(basename $DL_URL) -C /tmp/
  mv /tmp/$(basename $DL_URL .tar.gz)/$PG $INSTALL_DIR
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

