#!/bin/bash

usage() {
    prg_name=`basename $0`
    cat <<EOM
  Usage : $prg_name [-h]
EOM
  exit 1
}

main() {
  # TODO
  cd "`dirname $0`"
  # read
  echo "Finish"
}

while getopts "h:v" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
  esac
done
shift `expr $OPTIND - 1`
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

