#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  local cwd=$(pwd)
  cd $(dirname $0)/completion/

  curl -O https://raw.github.com/git/git/master/contrib/completion/git-completion.bash
  curl -o _git https://raw.github.com/git/git/master/contrib/completion/git-completion.zsh
  curl -o _padrino https://raw.github.com/matthias-guenther/padrino-zsh-completion/master/_padrino
  curl -o _loga https://raw.github.com/tacahiroy/loga-zsh-completion/master/_loga_zsh_completion.zsh

  cd $cwd
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

