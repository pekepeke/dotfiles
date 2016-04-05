#!/bin/bash

download_release_package() {
  PACKAGE="$1"
  VER="$2"

  if [ -z "$PACKAGE" -o -z "$VER" ]; then
    echo "invalid arguments: $*" 1>&2
    return 1
  fi

  EXT=$(detect_ext zip)
  URL=$(get_release_binary_url "$PACKAGE" "$VER" "$EXT")

  cd /tmp/
  local LOCAL_PACKAGE=/tmp/$(basename $PACKAGE).$EXT
  if [ $EXT = zip ] ; then
    curl -L "${URL}" -o $LOCAL_PACKAGE
    unzip $LOCAL_PACKAGE
  else
    curl -L "${URL}" -o $LOCAL_PACKAGE
    tar zxvf $LOCAL_PACKAGE
  fi
}

detect_ext() {
  EXT="$1"
  local PLATFORM=$(uname -s | tr [A-Z] [a-z])
  [ -n "$EXT" -a "$PLATFORM" = "linux" ] && EXT=tar.gz
  echo $EXT
}

get_release_binary_url() {
  PACKAGE="$1"
  VER="$2"
  EXT="$3"

  local ARCH=$(uname -i)
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
