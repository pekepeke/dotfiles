#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  platform=$(uname -a)
  if [[ "$platform" !~ Darwin ]]; then
    echo "available for osx only"
    return 1
  fi
  # TODO
  #latest_ver=$(curl -s https://github.com/cappuccino/cappuccino/tags | grep zipball | grep title | perl -ne '$_=~s/^.*title="([\w0-9\.-]+)".*/$1/g; print' | head -1 )
  latest_ver=$(curl -s https://github.com/cappuccino/cappuccino/tags | grep zipball | grep title | head -1 | perl -ne '$_=~s/^.*title="([\w0-9\.-]+)".*/$1/g; print')
  curl https://raw.github.com/cappuccino/cappuccino/$latest_ver/bootstrap.sh | sh
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

