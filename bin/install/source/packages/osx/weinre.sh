#!/bin/bash

APPLICATION_DIR=/Applications
# UNIX_INSTALL_DIR=
DL_HOST=https://github.com
PAGE_URI=callback/callback-weinre/archives/master
temp_dir="/tmp/$(basename $0)-$$.tmp"
INSTALL_PORT=8080
INSTALL_BIND_ADDR=0.0.0.0

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

  platform=$(uname -a)
  if [[ "$platform" =~ Darwin ]]; then
    ZIP_URI=$(curl -s $DL_HOST/$PAGE_URI | perl -ne 'print $1 if $_ =~ /a href="(.*-mac-.*.zip)">/')
  else
    ZIP_URI=$(curl -s $DL_HOST/$PAGE_URI | perl -ne 'print $1 if $_ =~ /a href="(.*-jar-.*.zip)">/')
  fi

  if [[ $ZIP_URI = ^https?: ]]; then
    ZIP_DL_URL=$ZIP_URI
  elif [[ $ZIP_URI =~ ^/ ]]; then
    ZIP_DL_URL=$DL_HOST$ZIP_URI
  else
    ZIP_DL_URL=$DL_HOST/$PAGE_URI/$ZIP_URI
  fi

  [ ! -e $temp_dir ] && mkdir -p $temp_dir
  cd $temp_dir

  echo download from $ZIP_DL_URL
  curl -O $ZIP_DL_URL
  unzip $(basename $ZIP_DL_URL)
  cd weinre-mac/

  if [ $(grep "boundHost" weinre.app/Contents/MacOS/launcher | wc -l) -eq 0 ]; then
    sed -ie 's/GUIMain/GUIMain -httpPort '$INSTALL_PORT' -boundHost '$INSTALL_BIND_ADDR'/' weinre.app/Contents/MacOS/launcher
  else
    echo "already setupped"
  fi
  mv weinre.app $APPLICATION_DIR/weinre.app

  rm -rf $temp_dir
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

