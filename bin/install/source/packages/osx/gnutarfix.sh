#!/bin/bash

opt_uninstall=0
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  if [ $opt_uninstall -eq 1 ];then
    echo sudo ln -fs /usr/bin/bsdtar /usr/bin/tar
    sudo ln -fs /usr/bin/bsdtar /usr/bin/tar
  else
    echo sudo ln -fs /usr/bin/gnutar /usr/bin/tar
    sudo ln -fs /usr/bin/gnutar /usr/bin/tar
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvs:" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    u)
    opt_uninstall=1
    ;;
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

