#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  local PHP=/usr/bin/php
  local PECL=/usr/bin/pecl
  local PEAR=/usr/bin/pear

  if [ ! -e /private/etc/php.ini ]; then
    sudo cp /private/etc/php.ini.default /private/etc/php.ini
  fi
  sudo $PHP /usr/lib/php/install-pear-nozlib.phar
  $PEAR config-set php_ini /etc/php.ini
  $PECL config-set php_ini /etc/php.ini
  sudo $PEAR upgrade-all

  local EXT_DIR=$($PECL config-get ext_dir)

  [ ! -e $EXT_DIR/apc.so ] && sudo $PECL install apc
  [ ! -e $EXT_DIR/xdebug.so ] && sudo $PECL install xdebug
  [ ! -e $EXT_DIR/xhprof.so ] && sudo $PECL install xhprof-beta

  cat <<EOM
please add your php.ini below codes

zend_extension="$EXT_DIR/xdebug.so"
extension="$EXT_DIR/apc.so"
extension="$EXT_DIR/xhprof.so"

EOM
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

