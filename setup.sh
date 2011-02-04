#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  cd $(dirname $0)
  CDIR=$(pwd)
  if [ ! -e $HOME/.rc-org ]; then
    mkdir $HOME/.rc-org
    for F in .bash_profile .bashrc .screenrc .vimrc ;do
      mv $HOME/$F $HOME/.rc-org
    done
  fi
  for F in .?* ;do
    if [ "$F" == "." -o "$F" == ".." -o "$F" == "setup.sh" ] ; then
      echo skip $F
    else
      ln -s $CDIR/$F $HOME
    fi
  done
  echo please execute under commands
  echo git submodule init
  echo git submodule update
  vp_dir=$CDIR/.vim/bundle/vimproc/
  if [ ! -e "$vp_dir/autoload/proc.so" ]; then
    cd $CDIR/.vim/bundle/vimproc
    case $OSTYPE in
      darwin*)
        make -f make_mac.mak
        ;;
      *)
        make -f make_gcc.mak
        ;;
    esac
  fi
}

while getopts "h:v" opt; do
  case $opt in
    h) 
      usage ;;
    v) ;;
  esac
done
shift `expr $OPTIND - 1`
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

