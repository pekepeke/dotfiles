#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  executable xh || curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
  executable starship || curl -sS https://starship.rs/install.sh | BIN_DIR=~/.local/bin sh -b ~/.local/bin
  executable zoxide || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

  for cmd in bat eza fzf lazygit lazydocker gitui xremap; do
    myinstall package $cmd
  done
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

