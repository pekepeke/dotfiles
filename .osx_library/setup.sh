#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

trace() {
  echo $*
  $*
}

main() {
  local cwd=$(pwd)
  local HOME_LIB="$HOME/Library"
  cd $(dirname $0)

  (
  IFS=$'\n'
  #for f in $(ls .); do
  for f in "Application Support"; do
    if [ -d $f ]; then
      for d in $(ls $f); do
        local APP_PREF=$HOME_LIB/$f/$d
        if [ -e "$APP_PREF.org" ]; then
          echo "skip : $APP_PREF"
        else
          if [ -e "$APP_PREF" ]; then
            trace mv "$APP_PREF" "$APP_PREF.org"
          fi
          trace ln -s "$PWD/$f/$d" "$APP_PREF"
        fi
      done
    fi
  done
  for f in $(ls .); do
    if [ $f = "Application Support" ]; then
      # echo "skip"
      continue
    fi
    if [ -d $f ]; then
      for fp in $(find $f -type f); do
        local APP_PREF=$HOME_LIB/$fp
        # TODO
        if [ -e "$APP_PREF.org" ]; then
          echo "skip : $APP_PREF"
        else
          if [ -e "$APP_PREF" ]; then
            echo trace mv "$APP_PREF" "$APP_PREF.org"
          fi
        fi
        echo trace ln -s "$PWD/$fp" "$APP_PREF"
      done
    fi
  done
  )

  cd $cwd
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

