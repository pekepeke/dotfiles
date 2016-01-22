#!/bin/bash

USER_COMPLETION_DIR="$HOME/.zsh/zfunc/completion"
DIRS="
$HOME/.zsh/plugins/zsh-completions/src
$HOME/.zsh/plugins/zsh-perl-completions
"

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  local d f filename
  local cnt=0
  for d in $DIRS ; do
    for f in $(find $d -type f); do
      filename=$(basename $f)
      if [ -e $USER_COMPLETION_DIR/$f ]; then
        echo "duplicate definition found: $USER_COMPLETION_DIR/$f"
      fi
      cnt=$(($cnt+1))
    done
  done
  echo "finish: $cnt files."
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

