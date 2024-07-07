#!/bin/bash

GIT_URL="git://github.com/pekepeke/dotfiles.git"
LOCAL_DIR="$HOME/.github-dotfiles"
OS_DIFFER_FILES=".xinitrc"
BACKUP_FILES=".bash_profile .bashrc .screenrc .vimrc"
SKIP_FILES=". .. .git setup.sh .projections.json"
TEMPLATE_FILES=".gitattributes_global_tmpl"
INITIALIZE_FILES=""
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

forematchin() {
  local SRC=$1
  shift
  for K in $*; do
    if [ $(echo "$SRC" | grep -e "^$K.*" | wc -l) -eq 1 ]; then
      return 0
    fi
  done
  return 1
}

purge_files() {
  local RED="\033[1;31m"
  local DEFAULT="\033[00m"

  local files="$(find ~ -maxdepth 1 -type l -name '.*')"
  files="${files} ~/bin"
  for f in $files; do
    if [ -e $f -a ! -e "$(readlink $f)" ] ; then
      echo -e ${RED}rm "$f"${DEFAULT}
      rm "$f"
    fi
  done
  for f in ~/.* ; do [ -L $f -a ! -e $f ] && echo -e ${RED}rm "$f"${DEFAULT} && rm $f ; done
}

exec_install() {
  local RED="\033[1;31m"
  local GREEN="\033[1;32m"
  local YELLOW="\033[1;33m"
  local BLUE="\033[1;34m"
  local GRAY="\033[1;37m"
  local DEFAULT="\033[00m"
  if [ ! -e $(basename $0) ]; then
    if [ ! -e $LOCAL_DIR ]; then
      git clone ${GIT_URL} ${LOCAL_DIR}
    fi
    cd ${LOCAL_DIR}
  fi

  local CDIR=$(pwd)

  if [ ! -e $HOME/.rc-org ]; then
    mkdir $HOME/.rc-org
    for F in $BACKUP_FILES ;do
      echo ${HOME}/$F
      if [ -e "${HOME}/${F}" -a ! -L "${HOME}/${F}" ]; then
        echo -e "${RED}mv $HOME/$F $HOME/.rc-org${DEFAULT}"
        mv $HOME/$F $HOME/.rc-org
      fi
    done
  fi
  local skipfiles=""
  local execfiles=""
  for F in .?* bin ;do
    if matchin "$F" $SKIP_FILES ; then
      # echo -e "${GRAY}skip object $F${DEFAULT}"
      skipfiles="$skipfiles\n${GRAY}skip object $F${DEFAULT}"
    elif [ "$F" = ".config" ]; then
      for fname in .config/* ; do
        echo $fname
        if [ ! -L "$HOME/$fname" -a ! -d "$HOME/$fname" ]; then
          execfiles="$execfiles\n${YELLOW}ln -s $CDIR/${fname} $HOME/${fname}${DEFAULT}"
          ln -s "$CDIR/${fname}" "$HOME/${fname}"
        fi
      done

    elif forematchin "$F" $OS_DIFFER_FILES ; then
      local base=${F%.*}
      local prefix=""
      case "$OSTYPE" in
        solaris*)
          prefix=solaris
          ;;
        darwin*)
          prefix=osx
          ;;
        linux*)
          prefix=linux
          ;;
        bsd*)
          prefix=bsd
          ;;
        *)        echo "unknown: $OSTYPE - $" 1>&2 ;;
      esac

      # echo $F $base $prefix
      if [ x"$prefix" != x -a x"$F" = x"${base}.${prefix}" -a ! -L "$HOME/${base}" ]; then
        execfiles="$execfiles\n${YELLOW}ln -s $CDIR/$F $HOME/${base}${DEFAULT}"
        ln -s "$CDIR/$F" "$HOME/${base}"
      fi
      # ln -s $CDIR/$F $HOME
    elif [ -e "$HOME/$F" ]; then
      # echo -e "${GRAY}skip $F${DEFAULT}"
      skipfiles="$skipfiles\n${GRAY}skip $F${DEFAULT}"
    elif matchin "$F" $COPY_FILES ; then
      execfiles="$execfiles\n${GREEN}cp $CDIR/$f $HOME${DEFAULT}"
      cp $CDIR/$f $HOME
    else
      execfiles="$execfiles\n${YELLOW}ln -s $CDIR/$F $HOME${DEFAULT}"
      ln -s $CDIR/$F $HOME
    fi
  done
  [ x"$skipfiles" != x"" ] && echo -e $skipfiles
  [ x"$execfiles" != x"" ] && echo -e $execfiles
  for f in $TEMPLATE_FILES; do
    real_f=${f%%_tmpl}
    if [ ! -e "$HOME/$real_f" ] ; then
      cp $CDIR/$f $HOME/$real_f \
        && echo "${YELLOW}copy $HOME/${real_f}${DEFAULT}"
    fi
  done

  if [ ! -e ~/.ssh/config ]; then
    ~/.ssh_config.default.sh -s
  fi
  ~/.gitconfig.init.sh
  [ -x ~/.docker/config.json.template.sh ] && ~/.docker/config.json.template.sh

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
  $files="${files} ~/bin"

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

### please exec following commands

rm $LOCAL_DIR

EOM
}

main() {
  cd $(dirname $0)

  if ! which git >/dev/null 2>&1; then
    echo "command not found: git" 1>&2
    git rev-parse >/dev/null 2>&1
    exit 1
  fi

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

