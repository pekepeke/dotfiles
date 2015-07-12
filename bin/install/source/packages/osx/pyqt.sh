#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

latest_ver() {
  local url=$1
  local keyword=$2
  curl -Ls ${url} | grep ${keyword} | grep tar.gz | grep -v snapshot | perl -ne 's/.*href="([^"]*)".*/$1/;s/^[a-zA-Z\-]+|\.tar\.gz$//g;print;'
}

main() {
  PY_VER=$(python -V 2>&1 | awk '{print $2}')
  #SIP_VER=4.12.4
  SIP_VER=$(latest_ver http://www.riverbankcomputing.com/static/Downloads/sip4/ sip)
  #PYQT_VER=4.8.5
  PYQT_VER=$(latest_ver http://www.riverbankcomputing.com/static/Downloads/PyQt4/ mac)
  [ ! -e /tmp/pylib/${PY_VER} ] && mkdir -p /tmp/pylib/${PY_VER}
  cd /tmp/pylib/${PY_VER}

  if [ ! -e sip-${SIP_VER} ] ; then
    wget http://www.riverbankcomputing.com/static/Downloads/sip4/sip-${SIP_VER}.tar.gz
    tar zxvf sip-${SIP_VER}.tar.gz
  fi
  cd sip-${SIP_VER}
  python configure.py
  make && make install
  cd ..

  if [ ! -e PyQt-mac-gpl-${PYQT_VER} ] ; then
    wget http://www.riverbankcomputing.com/static/Downloads/PyQt4/PyQt-mac-gpl-${PYQT_VER}.tar.gz
    tar zxvf PyQt-mac-gpl-${PYQT_VER}.tar.gz
  fi
  cd PyQt-mac-gpl-${PYQT_VER}
  python configure.py
  make -j4 && make install
  cd ..
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

