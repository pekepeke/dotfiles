#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  [ ! -e ~/.bin ] && mkdir -p ~/.bin/
  curl -Lo ~/.bin/refactor.phar https://github.com/QafooLabs/php-refactoring-browser/releases/download/v0.1/refactor.phar
  chmod +x ~/.bin/refactor.phar
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

