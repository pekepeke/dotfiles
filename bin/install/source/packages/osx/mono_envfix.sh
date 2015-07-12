#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  platform=$(uname -a)
  if [[ "$platform" !~ Darwin ]]; then
    echo "available for osx only"
    return 1
  fi
  cd /var/tmp

   cat <<EOM > pango.aliases
"Lucida Grande" = "Hiragino Kaku Gothic Pro"
"Microsoft Sans Serif" = "Hiragino Kaku Gothic Pro"
"Courier New" = "Hiragino Kaku Gothic Pro"
EOM

  cat /Library/Frameworks/Mono.framework/Versions/Current/etc/gtk-2.0/gtkrc | perl -ne 's/^(\s*)gtk-font-name.*/$1gtk-font-name = "Osaka 12"/;s/^(\s*)font\s*=.*/$1fon t= "Osaka 14"/g;print;' > gtkrc

  ## copy files
  sudo cp pango.aliases /Library/Frameworks/Mono.framework/Versions/Current/etc/pango/

  [ ! -e /Library/Frameworks/Mono.framework/Versions/Current/etc/gtk-2.0/gtkrc.org ] && sudo cp /Library/Frameworks/Mono.framework/Versions/Current/etc/gtk-2.0/gtkrc /Library/Frameworks/Mono.framework/Versions/Current/etc/gtk-2.0/gtkrc.org
  sudo cp gtkrc /Library/Frameworks/Mono.framework/Versions/Current/etc/gtk-2.0/gtkrc

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

