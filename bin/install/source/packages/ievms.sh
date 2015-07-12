#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
Usage: $prg_name [-h] [version...]

  -h        : Show this message
  [version] : install versions(default=6 7 8 9)

Example: $prg_name 7 9

Notice:
IE6 only - Install network adapter drivers by opening the drivers CD image in the VM.
Once available and started in VirtualBox, the password for ALL VMs is "Password1".

EOM
  exit 1
}

main() {
  # platform=$(uname -s)
  # if [ "$platform" != Darwin ]; then
  #   echo "available for osx only"
  #   return 1
  # fi
  versions="$@"
  if [ x$versions = x ]; then
    curl -Ls https://raw.github.com/xdissent/ievms/master/ievms.sh | bash
  else
    curl -Ls https://raw.github.com/xdissent/ievms/master/ievms.sh | IEVMS_VERSIONS="$versions" bash
  fi
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

