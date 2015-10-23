#!/bin/bash

get_release_binary_url() {
  PACKAGE="$1"
  VER="$2"
  EXT="$3"

  local PLATFORM=$(uname -i)
  local PLATFORM=$(uname -s | tr [A-Z] [a-z])

  if [ "$ARCH" = "x86_64" ] ; then
    ARCH=amd64
  else
    ARCH=386
  fi
  [ -n "$EXT" -a "$PLATFORM" = "linux" ] && EXT=tar.gz
  [ -n "$EXT" ] && EXT=".${EXT}"

  echo "https://github.com/${PACKAGE}/releases/download/v${VER}/$(basename $PACKAGE)_${PLATFORM}_${ARCH}${EXT}"
}
