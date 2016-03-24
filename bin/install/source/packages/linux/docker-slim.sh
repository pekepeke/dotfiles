#!/bin/bash

VERSION=1.14
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  cd /tmp/
  [ ! -e ~/.bin/ ] && mkdir ~/.bin/
  curl -Lo docker-slim.zip https://github.com/cloudimmunity/docker-slim/releases/download/$VERSION/dist_linux.zip

  unzip docker-slim.zip
  mv dist_linux/docker-slim* ~/.bin
  rm docker-slim.zip
  rmdir dist_linux
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

