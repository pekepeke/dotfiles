#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  if [ -e /usr/local/googkit ]; then
    cd /usr/local/googkit
    git pull
  else
    git clone https://github.com/googkit/googkit /tmp/googkit
    if ! mv /tmp/googkit /usr/local/googkit; then
      sudo mv /tmp/googkit /usr/local/googkit
    fi
    if [ -e /usr/local/googkit ]; then
      echo "installed: /usr/local/googkit"
    else
      [ -e /tmp/googkit ] && rm -rf /tmp/googkit
    fi
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

