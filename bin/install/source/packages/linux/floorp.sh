#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  [ ! -e /usr/share/keyrings/Floorp.gpg ] && curl -fsSL https://ppa.floorp.app/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
  [ ! -e /etc/apt/sources.list.d/Floorp.list ] && sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list "https://ppa.floorp.app/Floorp.list"

  if [ ! -e /etc/apparmor.d/floorp -a -e /etc/apparmor.d/firefox ] ; then
    cat <<EOM | sudo tee /etc/apparmor.d/floorp
# This profile allows everything and only exists to give the
# application a name instead of having the label "unconfined"

abi <abi/4.0>,
include <tunables/global>

profile floorp /{usr/lib/floorp{,-esr,-beta,-devedition,-nightly},opt/floorp}/floorp{,-esr,-bin} flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/firefox>
}
EOM
    sudo systemctl restart apparmor
  fi

  sudo apt update
  sudo apt install floorp
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

