#!/bin/bash

packages() {
  cat <<EOM
pinta
gimp
inkscape
EOM
}

usage() {
  cat <<EOM
## install packages
EOM
  packages
}
main() {
  for p in $(packages); do
    sudo apt-get install $p
  done
}

while getopts "h" opt; do
  case $opt in
    h)
      usage ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"
