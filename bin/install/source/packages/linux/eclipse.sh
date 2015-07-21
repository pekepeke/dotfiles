#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  wget http://ftp.jaist.ac.jp/pub/eclipse/technology/epp/downloads/release/mars/R/eclipse-java-mars-R-linux-gtk-x86_64.tar.gz -O /tmp/eclipse.tar.gz
  tar xzvf /tmp/eclipse.tar.gz -C $HOME

  # $ECLIPSE_HOME/eclipse -nosplash \
  #   -application org.eclipse.equinox.p2.director \
  #   -profile SDKProfile \
  #   -destination $ECLIPSE_HOME \
  #   -repository http://download.eclipse.org/releases/mars \
  #   -installIU <plugin-id>

  # $ECLIPSE_HOME/eclipse -nosplash \
  #   -application org.eclipse.equinox.p2.director \
  #   -profile SDKProfile \
  #   -destination $ECLIPSE_HOME \
  #   -repository http://download.eclipse.org/releases/juno \
  #   -uninstallIU <plugin-id>
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

