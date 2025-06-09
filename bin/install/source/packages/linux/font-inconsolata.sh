#!/bin/bash


fonts_dir="$HOME/.local/share/fonts"
# fonts_dir="$HOME/.local/share/_fonts"

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {

  if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
  fi

  for font in "$@"; do
    zip_file="$font.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$zip_file"
    echo "Downloading $download_url"
    echo curl -LO "/tmp/$zip_file" "$download_url"
    wget -O "/tmp/$zip_file" "$download_url"
    unzip "/tmp/$zip_file" -d "/tmp/$font/"
    mv /tmp/$font/*.ttf $fonts_dir
    rm "/tmp/$zip_file"
    rm "/tmp/$font/" -rf
  done

  fc-cache -fv
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

set -euo pipefail
# main "$@"
main "Inconsolata"

