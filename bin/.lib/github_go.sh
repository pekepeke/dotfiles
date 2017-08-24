#!/bin/bash

get_latest_version() {
  PACKAGE="$1"
  T=/tmp/github_latest_$(echo $PACKAGE | base64)
  if [ ! -e $T ]; then
    curl https://api.github.com/repos/$PACKAGE/releases/latest > $T
  fi
  cat $T | python -c 'import sys,json; print json.load(sys.stdin)["tag_name"];'
}

download_release_package() {
  PACKAGE="$1"
  VER="$2"
  PACKAGE_BASENAME="$3"
  EXT="$4"

  if [ -z "$PACKAGE" -o -z "$VER" ]; then
    echo "invalid arguments: $*" 1>&2
    return 1
  fi

  [ -z "$PACKAGE_BASENAME" ] && PACKAGE_BASENAME=$(basename $PACKAGE)
  [ -z "$EXT" ] && EXT=$(detect_ext zip)
  echo "$PACKAGE" "$VER" $PACKAGE_BASENAME "$EXT"
  URL=$(get_release_binary_url "$PACKAGE" "$VER" $PACKAGE_BASENAME "$EXT")

  cd /tmp/
  local LOCAL_PACKAGE=/tmp/$(basename $PACKAGE).$EXT
  echo $URL
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
  PACKAGE_BASENAME="$3"
  EXT="$4"

  local ARCH=$(uname -i)
  local PLATFORM=$(uname -s | tr [A-Z] [a-z])

  if [ "$ARCH" = "x86_64" ] ; then
    ARCH=amd64
  else
    ARCH=386
  fi
  [ -z "$EXT" -a "$PLATFORM" = "linux" ] && EXT=tar.gz
  [ -n "$EXT" ] && EXT=".${EXT}"
  [ -z "$PACKAGE_BASENAME" ] && PACKAGE_BASENAME=$(basename $PACKAGE)


  echo "https://github.com/${PACKAGE}/releases/download/${VER}/${PACKAGE_BASENAME}_${PLATFORM}_${ARCH}${EXT}"
}
