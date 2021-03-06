#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  if ! which autoreconf >/dev/null 2>&1; then
    echo "please install autoconf."
    exit 1
  fi
  git clone https://github.com/universal-ctags/ctags.git /tmp/ctags --depth=1
  cd /tmp/ctags
  # autoreconf -vfi
  ./autogen.sh
  ./configure --enable-iconv
  make
  [ ! -e ~/.bin ] && mkdir -p ~/.bin
  cp ctags ~/.bin/
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

