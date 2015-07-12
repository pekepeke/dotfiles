#!/bin/bash

opt_uninstall=0

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]

-u : uninstall
EOM
  exit 1
}

main() {
  platform=$(uname -a)
  if [[ "$platform" !~ Darwin ]]; then
    echo "available for osx only"
    return 1
  fi
  if [ $opt_uninstall = 1 ]; then
    mv ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin ~/.Trash/
    mv ~/Library/Application\ Support/Alcatraz/ ~/.Trash/
  else
    # mkdir -p ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins;
    # curl -L http://goo.gl/xfmmt | tar zxv -C ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins
    curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hus:" opt; do
  case $opt in
    h)
      usage ;;
    u) opt_uninstall=1 ;;
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

