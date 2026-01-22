#!/bin/bash

VER=0.39.3
URL=https://sikiapp.net/archives/$VER/Siki-$VER.AppImage
ICO_URL=https://sikiapp.net/img/siki.svg
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {

  if which siki >/dev/null ; then
    echo "error: already installed." 1>&2
    return 0
  fi

  INSTALL_DIR=~/.local/bin
  SHARE_DIR=$HOME/.local/share

  curl -Lo $INSTALL_DIR/Siki.AppImage $URL
  [ -e $INSTALL_DIR/Siki.AppImage ] && chmod +x $INSTALL_DIR/Siki.AppImage

  if [ -e $SHARE_DIR/applications/Siki.desktop ]; then
    echo "# already exists: $SHARE_DIR/applications/Siki.desktop "
  else
    local CMD_OPTS=""
    if [ "$CHROMIUM_DISABLE_GPU" = "1" ]; then
      CMD_OPTS="--disable-gpu"
    fi
    if [ -e $SHARE_DIR/icons/siki.svg ]; then
      echo "# already exists: $SHARE_DIR/icons/siki.svg"
    else
      curl -L "$ICO_URL" -o $SHARE_DIR/icons/siki.svg
    fi

    cat <<EOM > $SHARE_DIR/applications/Siki.desktop
[Desktop Entry]
Name=Siki
Exec=$INSTALL_DIR/Siki.AppImage $CMD_OPTS
Icon=$SHARE_DIR/icons/siki.svg
Type=Application
Categories=Utility;
EOM
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


