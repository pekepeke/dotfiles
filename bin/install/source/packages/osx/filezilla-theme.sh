#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  DST=/Applications/FileZilla.app/resources
  if [ ! -e $DST ]; then
    echo "directory not found : $DST"
    exit 1
  fi

  cd ~/Downloads
  curl -O http://wikimetru.com/macish/Mac-ish.zip
  curl -O http://gnome-look.org/CONTENT/content-files/129419-awoken.zip
  unzip 129419-awoken.zip
  mv awoken $DST
  unzip Mac-ish.zip
  mv Mac-ish $DST
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

