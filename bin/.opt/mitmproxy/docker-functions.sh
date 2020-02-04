#!/bin/sh

opt_port=8080

is_int() {
  [ "$1" -eq 0 ] 2> /dev/null
  test $? -ne 2
  return $?
}

err_p() {
  echo "$*" 1>&2
}

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

