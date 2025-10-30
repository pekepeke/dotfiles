#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

make_desktop() {
  BIN_DIR=$HOME/.local/bin
  SHARE_DIR=$HOME/.local/share
  [ ! -e $SHARE_DIR/icons ] && mkdir -p $SHARE_DIR/icons
  if [ -e $SHARE_DIR/icons/obsidian.png ]; then
    echo "# already exists: $SHARE_DIR/icons/obsidian.png"
  else
    curl -L "https://avatars.githubusercontent.com/u/65011256?s=200&v=4" -o $SHARE_DIR/icons/obsidian.png
  fi

  if [ -e  ]; then
    echo "# already exists: $SHARE_DIR/applications/Obsidian.desktop "
  else
    cat <<EOM > $SHARE_DIR/applications/Obsidian.desktop
[Desktop Entry]
Name=Obsidian
Exec=$BIN_DIR/obsidian.appimage --no-sandbox
Icon=$SHARE_DIR/icons/obsidian.png
Type=Application
Categories=Utility;
EOM
  fi



}

main() {
  # TODO
  TEMP=/tmp/
  AUTHOR=obsidianmd
  PG=obsidian-releases
  INSTALL_DIR=~/.local/bin
  # if [ -e "$INSTALL_DIR/$pg" ]; then
  #   echo "already installed: $INSTALL_DIR/$pg"
  #   return 0
  # fi
  arch=`uname -m`

# | grep "browser_download_url.*linux-$arch-gnome" \
# | grep "browser_download_url.*linux-$arch-kde" \
# | grep "browser_download_url.*linux-$arch-wlroots" \
echo curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest
  curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest > $TEMP/$PG.json
  cdir=`pwd`

  cd $cdir
  dl_url="$(cat $TEMP/$PG.json \
| grep "browser_download_url.*\\.[0-9]*\\.AppImage" \
| cut -d : -f 2,3 \
| tr -d \")"

  if [ "$dl_url" = "" ]; then
    echo "url not found" 1>&2
    return 1
  fi
  cd $TEMP
  echo curl -LO $dl_url
  curl -LO $dl_url
  mv $(basename $dl_url) $INSTALL_DIR/obsidian.appimage
  chmod +x $INSTALL_DIR/obsidian.appimage

  # unzip $(basename $dl_url) -d $TEMP/
  # mv $TEMP/$pg $INSTALL_DIR/$PG-$TKTYPE
  # rm $(basename $dl_url)
  cd $cdir

  # rm -f $(basename $dl_url)
  rm -f $TEMP/$PG.json

  make_desktop
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

