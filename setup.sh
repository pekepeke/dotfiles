#!/bin/bash

GIT_URL="git://github.com/pekepeke/dotfiles.git"
LOCAL_DIR="$HOME/.github-dotfiles"
BACKUP_FILES=".bash_profile .bashrc .screenrc .vimrc"
SKIP_FILES=". .. .git setup.sh"
COPY_FILES=""

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

  if [ ! -e $(basename $0) ]; then
    if [ ! -e ~/.github-dotfiles ]; then
      git clone ${GIT_URL} ${LOCAL_DIR}
    fi
    cd ${LOCAL_DIR}
  fi
  CDIR=$(pwd)
  if [ ! -e $HOME/.rc-org ]; then
    mkdir $HOME/.rc-org
    for F in "$BACKUP_FILES" ;do
      mv $HOME/$F $HOME/.rc-org
    done
  fi
  for F in .?* ;do
    if matchin "$F" $SKIP_FILES ; then
      echo skip object $F
    elif [ -e "$HOME/$F" ]; then
      echo skip $F
    elif matchin "$F" $COPY_FILES ; then
      echo cp $CDIR/$f $HOME
      cp $CDIR/$f $HOME
    else
      echo ln -s $CDIR/$F $HOME
      ln -s $CDIR/$F $HOME
    fi
  done
  if [ -e "$CDIR/.gitmodules" ]; then
    git submodule init
    git submodule update
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

