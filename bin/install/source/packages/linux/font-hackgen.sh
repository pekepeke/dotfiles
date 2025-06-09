#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  fonts_dir="$HOME/.local/share/fonts"
  AUTHOR=yuru7
  PG=HackGen

  if [ ! -d "$fonts_dir" ]; then
    mkdir -p "$fonts_dir"
  fi

  DL_URL="$(curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest \
    | grep "browser_download_url.*_NF_" \
    | cut -d : -f 2,3 \
    | tr -d ' \"')"
  # https://github.com/yuru7/HackGen/releases/download/v2.10.0/HackGen_NF_v2.10.0.zip
  echo "# Download from $DL_URL"
  curl -Lo "/tmp/$PG.zip" "$DL_URL"
  if [ ! -e /tmp/$PG.zip  ]; then
    echo "# download failed"
    exit 2
  fi
  unzip "/tmp/$PG.zip" -d "/tmp/$PG/"
  mv /tmp/$PG/HackGen_NF*/*.ttf $fonts_dir
  rm "/tmp/$PG.zip"
  rm "/tmp/$PG/" -rf
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

