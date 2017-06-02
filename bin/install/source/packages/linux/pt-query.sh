#!/bin/bash

VERSION=0.1-4
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  cd /tmp
  if which pt-query-digest > /dev/null 2>&1 ; then
    wget https://repo.percona.com/apt/percona-release_${VERSION}.$(lsb_release -sc)_all.deb
    sudo dpkg -i percona-release_${VERSION}.$(lsb_release -sc)_all.deb
    sudo apt-get install percona-toolkit
  fi
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

