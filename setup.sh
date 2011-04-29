#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

matchin() {
  SRC=$1
  shift
  for K in $*; do
    if [ "x$SRC" = "x$K" ]; then
      return 0
    fi
  done
  return 1
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
    # if [ "$F" == "." -o "$F" == ".." -o "$F" == ".git" -o "$F" == "setup.sh" ] ; then
    if matchin "$F" "." ".." ".git" "setup.sh" ; then
      echo skip object $F
    elif [ -e "$HOME/$F" ]; then
      echo skip $F
    else
      echo ln -s $CDIR/$F $HOME
      ln -s $CDIR/$F $HOME
    fi
  done
  vp_dir=$CDIR/.vim/bundle/vimproc/autoload
  if [ ! -e "$vp_dir" ]; then
    git submodule init
    git submodule update
  fi
  #if [ ! -e "$vp_dir/autoload/proc.so" ]; then
  # cd $CDIR/.vim/bundle/vimproc
  # case $OSTYPE in
    # darwin*)
      # make -f make_mac.mak
      # ;;
    # *)
      # make -f make_gcc.mak
      # ;;
  # esac
  #fi
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

