#!/bin/bash


usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

print_uinput_help() {
  cat <<EOM
# If you want to run xremap without sudo, input the following command.

lsmod | grep uinput
# if it shows up empty
echo uinput | sudo tee /etc/modules-load.d/uinput.conf

sudo gpasswd -a $USER input
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules

# reboot the machine afterwards or try
sudo modprobe uinput
sudo udevadm control --reload-rules && sudo udevadm trigger

EOM
  if [ ! -z "$WAYLAND_DISPLAY" -a ! -z "$GNOME_SETUP_DISPLAY" ]; then
    echo "# Please install gnome extension for xremap."
    echo "# https://extensions.gnome.org/extension/5060/xremap/"
  fi
}

make_systemd_conf() {
  [ ! -e ~/.config/systemd/user/ ] && mkdir -p ~/.config/systemd/user/
  cat <<EOM > ~/.config/systemd/user/xremap.service
[Unit]
Description=xremap
[Service]
KillMode=process
ExecStartPre=/usr/bin/xhost +SI:localuser:root
ExecStart=$HOME/.local/bin/xremap $HOME/.config/xremap/config.yml
Type=simple
Restart=always
RestartSec=10s
Environment=DISPLAY=:0
[Install]
WantedBy=default.target
EOM

  cat <<EOM
# Enter the following command manually
cat ~/.config/systemd/user/xremap.service
systemctl --user enable xremap
systemctl --user start xremap

EOM

}

make_resume_conf() {

  if [ ! -e /usr/lib/systemd/system-sleep/$USER-on_resume.sh ]; then

    echo "# try to create file: /usr/lib/systemd/system-sleep/$USER-on_resume.sh"
    cat <<EOM | sudo tee /usr/lib/systemd/system-sleep/$USER-on_sleep.sh
#!/bin/sh

case \$1/\$2 in
  pre/*)
    ;;
  post/*)
    # for s in xremap denops-shared-server; do
    for s in xremap ; do
      if systemctl --user --quiet -M $USER@ is-active \$s; then
        systemctl --user --quiet -M $USER@ restart \$s
      fi
      # [ \$0 -eq 0 ] && systemctl --user -M $USER@ restart \$s
    done
    ;;
esac

EOM
    sudo chmod +x /usr/lib/systemd/system-sleep/$USER-on_sleep.sh
  fi

  #cat <<EOS | sudo tee /etc/pm/sleep.d/90-$USER-xremap.sh
##!/bin/sh

## XDG_RUNTIME_DIR=/run/user/$(id -u $USER) sudo -H -u $USER systemctl --user restart xremap
#systemctl --user -M $USER@ restart xremap
#EOS
#sudo chmod +x /etc/pm/sleep.d/90-$USER-xremap.sh
#cat <<EOM
#EOM

}

main() {
  TEMP=/tmp/
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
  curl -s https://api.github.com/repos/$AUTHOR/$PG/releases/latest > $TEMP/$PG.json
  CDIR=`pwd`

  for TKTYPE in x11 gnome kde; do
    cd $CDIR
    DL_URL="$(cat $TEMP/$PG.json \
| grep "browser_download_url.*linux-$ARCH-$TKTYPE" \
| cut -d : -f 2,3 \
| tr -d \")"

    if [ "$DL_URL" = "" ]; then
      echo "url not found" 1>&2
      return 1
    fi
    cd $TEMP
    echo curl -LO $DL_URL
    curl -LO $DL_URL
    unzip $(basename $DL_URL) -d $TEMP/
    mv $TEMP/$PG $INSTALL_DIR/$PG-$TKTYPE
    rm $(basename $DL_URL)
    cd $CDIR
  done

  # rm -f $(basename $DL_URL)
  rm -f $TEMP/$PG.json

  print_uinput_help

  if [ ! -z "$WAYLAND_DISPLAY" ] ; then
    if [ ! -z "$GNOME_SETUP_DISPLAY" ] ; then
      ln -s $INSTALL_DIR/$PG-gnome $INSTALL_DIR/$PG
    else
      ln -s $INSTALL_DIR/$PG-kde $INSTALL_DIR/$PG
    fi
  else
    ln -s $INSTALL_DIR/$PG-x11 $INSTALL_DIR/$PG
  fi

  make_systemd_conf

  make_resume_conf
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

