#!/bin/sh

is_int() {
  [ "$1" -eq 0 ] 2> /dev/null
  test $? -ne 2
  return $?
}

err_p() {
  echo "$*" 1>&2
}


