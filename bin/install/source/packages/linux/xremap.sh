#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}
print_service_xremap() {
  cat <<EOM
[Unit]
Description=xremap

[Service]
KillMode=process
ExecStart=$HOME/.bin/xremap $HOME/.xremap
ExecStop=/usr/bin/killall xremap
Restart=always
Environment=DISPLAY=:0.0

[Install]
WantedBy=graphical.target
EOM
}

main() {
  cd /tmp
  [ ! -e ~/.bin ] && mkdir -p ~/.bin/
  [ ! -e xremap ] && git clone https://github.com/k0kubun/xremap
  cd xremap
  git pull
  if make && make DESTDIR=~/.bin/ install ; then
    [ ! -e ~/.config/systemd/user ] && mkdir -p ~/.config/systemd/user
    print_service_xremap > ~/.config/systemd/user/xremap.service
    # systemctl --user enable xremap
    # systemctl --user restart xremap
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

