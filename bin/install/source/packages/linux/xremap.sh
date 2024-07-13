#!/bin/bash


usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  AUTHOR=xremap
  PG=xremap
  INSTALL_DIR=~/.local/bin
  # if [ -e "$INSTALL_DIR/$PG" ]; then
  #   echo "already installed: $INSTALL_DIR/$PG"
  #   return 0
  # fi
  ARCH=`uname -m`
# | grep "browser_download_url.*linux-$ARCH-gnome" \
# | grep "browser_download_url.*linux-$ARCH-kde" \
# | grep "browser_download_url.*linux-$ARCH-wlroots" \
  curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest > /tmp/$PG.json

  for TKTYPE in x11 gnome kde; do
    DL_URL="$(cat /tmp/$PG.json \
| grep "browser_download_url.*linux-$ARCH-x11" \
| cut -d : -f 2,3 \
| tr -d \")"

    if [ "$DL_URL" = "" ]; then
      echo "url not found" 1>&2
      return 1
    fi
    echo curl -LO $DL_URL
    curl -LO $DL_URL
    unzip $(basename $DL_URL) -d /tmp/
    mv /tmp/$PG $INSTALL_DIR/$PG-$TKTYPE
  done

  # rm -f $(basename $DL_URL)
  rm -f /tmp/$PG.json

  cat <<EOM
# Running xremap without sudo

lsmod | grep uinput
# if it shows up empty
echo uinput | sudo tee /etc/modules-load.d/uinput.conf

sudo gpasswd -a YOUR_USER input
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules

# reboot the machine afterwards or try
sudo modprobe uinput
sudo udevadm control --reload-rules && sudo udevadm trigger


EOM
  cat <<EOM > ~/.config/systemd/user/xremap.service
[Unit]
Description=xremap
[Service]
KillMode=process
ExecStartPre=/usr/bin/xhost +SI:localuser:root
ExecStart=$HOME/.local/bin/xremap-x11 $HOME/.config/xremap/config.yml
Type=simple
Restart=always
RestartSec=10s
Environment=DISPLAY=:0
[Install]
WantedBy=default.target
EOM
  cat <<EOM
cat ~/.config/systemd/user/xremap.service
systemctl --user enable xremap
systemctl --user start xremap
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

