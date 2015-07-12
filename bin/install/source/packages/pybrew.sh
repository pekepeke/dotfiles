#!/bin/bash

opt_with_pythons=0
install_ver=2.7.3
additional_install_vers="3.2.1"
OPTION="-v -j4 --framework"
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  curl -kL https://github.com/utahta/pythonbrew/raw/master/pythonbrew-install | sh
  source $PYTHONBREW_ROOT/etc/bashrc
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvp" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"
