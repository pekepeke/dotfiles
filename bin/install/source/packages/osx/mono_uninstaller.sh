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
  #This script removes Mono from an OS X System.  It must be run as root

  rm -r /Library/Frameworks/Mono.framework

  rm -r /Library/Receipts/MonoFramework-*
  # In 10.6+ the receipts are stored here
  rm /var/db/receipts/com.ximian.mono*

  for dir in /usr/bin /usr/share/man/man1 /usr/share/man/man3 /usr/share/man/man5; do
     (cd ${dir};
      for i in `ls -al | grep /Library/Frameworks/Mono.framework/ | awk '{print $9}'`; do
        rm ${i}
      done);
  done
}

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
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

