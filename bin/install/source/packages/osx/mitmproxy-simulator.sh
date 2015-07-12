#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  cd /tmp
  [ ! -e ADVTrustStore ] && git clone https://github.com/ADVTOOLS/ADVTrustStore.git
  cd ADVTrustStore
  ./iosCertTrustManager.py -a ~/.mitmproxy/mitmproxy-ca-cert.pem
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
