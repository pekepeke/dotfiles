#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  if [ ! -e $HOME/.github-dotfiles ]; then
    #git clone https://github.com/pekepeke/dotfiles.git ~/.github-dotfiles
    git clone git@github.com:pekepeke/dotfiles.git ~/.github-dotfiles
    cd ~/.github-dotfiles
    git submodule init
    git submodule update
    sh setup.sh
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hv" opt; do
  case $opt in
    h) 
      usage ;;
    v) ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

