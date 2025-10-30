#!/bin/bash

FORCE=0
UNINSTALL=0
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

print-cliphist-systemd() {

  cat <<EOM
[Unit]
Description= #Your service description

[Service]
Type=simple
Restart=always
RestartSec=10s
KillMode=process
# EnvironmentFile= # path to environment file or comment out this line
# WorkingDirectory= # path to current directory or comment out this line
ExecStart= wl-paste --watch cliphist store
# ExecStop=/bin/kill -WINCH ${MAINPID}
# KillSignal=SIGCONT
# PrivateTmp=true

[Install]
WantedBy=default.target
EOM
}

print-clip-desktop() {

  cat <<EOM
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
# NoDisplay=true
Exec=cliphist list | wofi -S dmenu | cliphist decode | wl-copy
Name=Clipboard
Comment=clipboard
EOM

}

install() {
  # command check
  for c in cliphist wofi wl-copy; do
    if ! which $c >/dev/null 2>&1 ; then
      echo "command not found : $c" >&2
      return 1
    fi
  done
  if [ ! -e  ~/.config/systemd/user/cliphist.service -o $FORCE -eq 1 ]; then
    echo "create file:  ~/.config/systemd/user/cliphist.service"
    print-cliphist-systemd > ~/.config/systemd/user/cliphist.service
    systemctl --user daemon-reload
    systemctl --user enable cliphist
    systemctl --user start cliphist
  fi
  if [ ! -e  ~/.local/share/applications/clipboard.desktop -o $FORCE -eq 1 ]; then
    echo "create file: ~/.local/share/applications/clipboard.desktop"
    print-clip-desktop > ~/.local/share/applications/clipboard.desktop
  fi
}

uninstall() {

  if [ -e ~/.config/systemd/user/cliphist.service ]; then
    systemctl --user stop cliphist
    systemctl --user disable cliphist
    rm ~/.config/systemd/user/cliphist.service
    systemctl --user daemon-reload
  fi
  if [ -e  ~/.local/share/applications/clipboard.desktop ]; then
    rm ~/.local/share/applications/clipboard.desktop
  fi
}

main() {
  if [ $UNINSTALL -eq 0 ]; then
    install
  else
    uninstall
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvfus:" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    f) FORCE=1 ;;
    u) UNINSTALL=1 ;;
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

