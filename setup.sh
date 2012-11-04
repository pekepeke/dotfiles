#!/bin/bash

GIT_URL="git://github.com/pekepeke/dotfiles.git"
LOCAL_DIR="$HOME/.github-dotfiles"
BACKUP_FILES=".bash_profile .bashrc .screenrc .vimrc"
SKIP_FILES=". .. .git setup.sh"
COPY_FILES=""

opt_uninstall=0

usage() {
  local prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]

-h   : show usage
-u   : uninstall
EOM
  exit 1
}

matchin() {
  local SRC=$1
  shift
  for K in $*; do
    if [ "x$SRC" = "x$K" ]; then
      return 0
    fi
  done
  return 1
}

purge_files() {
  for f in $(find ~ -type l -maxdepth 1 -name '.*'); do
    if [ ! -e "$(readlink $f)" ] ; then
      echo rm "$f"
      rm "$f"
    fi
  done
}

exec_install() {
  if [ ! -e $(basename $0) ]; then
    if [ ! -e $LOCAL_DIR ]; then
      git clone ${GIT_URL} ${LOCAL_DIR}
    fi
    cd ${LOCAL_DIR}
  fi

  local CDIR=$(pwd)

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

exec_uninstall() {
  local files
  local fpath
  if [ -e $LOCAL_DIR ]; then
    files=$(find $LOCAL_DIR -maxdepth 1 -mindepth 1)
  else
    files=$(find ~/ -type l -name '.*' -maxdepth 1 -mindepth 1)
  fi

  for f in $files; do
    fpath=~/$(basename $f)
    if [ -e $fpath ]; then
      echo rm $fpath
      rm $fpath
    fi
  done
  for f in $(find ~/.rc-org -maxdepth 1 -mindepth 1); do
    fpath= ~/$(basename $f)
    echo "cp -p $f $fpath"
    cp -p $f $fpath
  done

  cat <<EOM

### please exec below command

rm $LOCAL_DIR

EOM
}

main() {
  cd $(dirname $0)

  purge_files

  if [ $opt_uninstall = 1 ]; then
    exec_uninstall
  else
    exec_install
  fi

}

while getopts "hu" opt; do
  case $opt in
    h)
      usage ;;
    # v) ;;
    u) opt_uninstall=1;;
  esac
done
shift `expr $OPTIND - 1`
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

