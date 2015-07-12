#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

function install_cpanm() {
	curl -L http://cpanmin.us | perl - --self-upgrade
}

function install_perlbrew() {
  if [ -z "$PERLBREW_ROOT" ]; then
    PERLBREW_ROOT=$HOME/perl5/perlbrew
  fi
	if [ -e "$PERLBREW_ROOT" ]; then
		echo "perlbrew is installed."
		return
	fi
	cd ~
	# curl -LO http://xrl.us/perlbrew
	# chmod +x perlbrew
	# ./perlbrew install
	curl -L http://xrl.us/perlbrewinstall | bash
	$PERLBREW_ROOT/bin/perlbrew init
}

main() {
	install_perlbrew
	install_cpanm
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hv" opt; do
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

