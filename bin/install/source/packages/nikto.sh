#!/bin/bash

NIKTO_URL="http://cirt.net/nikto/nikto-2.1.5.tar.gz"

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {

  if [ -e ~/.nikto ];then
    echo "Nikto is already installed." >&2
    exit 1
  fi

  local DIR_NAME=$(basename $NIKTO_URL .tar.gz)
  local TMP_DIR="/var/tmp/nikto-$(date +'%Y%m%d'))"
  [ ! -e $TMP_DIR ] && mkdir -p $TMP_DIR
  curl -L $NIKTO_URL | tar zx -C $TMP_DIR
  mv $TMP_DIR/$DIR_NAME ~/.nikto

  chmod +x ~/.nikto/*.pl

  [ -e $TMP_DIR ] && rm -rf $TMP_DIR

  echo "##### Installation is completed."
  echo "##### Please exec following command."
  echo ""
  echo "echo export PATH=\$PATH:\$HOME/.nikto >> ~/.bashrc"

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

