#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  #cdir=$(basename $0)
  libdir=$HOME/.homebrew/Formula
  hbdir=/usr/local/Library/Formula
  cd $cdir/Library
  for f in $(ls $libdir) ; do
    if [ ! -e $hbdir/$f ]; then
      echo ln -s $libdir/$f $hbdir/$f
      if ! ln -s $libdir/$f $hbdir/$f ; then
        echo fail
      fi
    fi
  done
}

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
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

