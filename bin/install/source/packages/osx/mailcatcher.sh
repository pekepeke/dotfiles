#!/bin/bash

opt_uninstall=0
PLIST=~/Library/LaunchAgents/me.mailcatcher.plist
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-hu]

  -h : show messages
  -u : uninstall
EOM
  exit 1
}

plist() {
  cat <<'EOM'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>me.mailcatcher</string>
    <key>ProgramArguments</key>
    <array>
    <string>sh</string>
    <string>-i</string>
    <string>-c</string>
    <string>$SHELL --login -c "mailcatcher --foreground"</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOM
}

install_plist() {
  if !which mailcatcher >/dev/null 2>&1; then
    echo command not found: mailcatcher 1>&2
    cat <<EOM 1>&2

## please install by following

gem install mailcatcher
EOM
    exit 1
  fi
  plist > $PLIST
  launchctl load $PLIST
}

uninstall_plist() {
  if [ ! -e "$PLIST" ]; then
    echo file not found $PLIST 1>&2
    exit 1
  fi
  launchctl unload $PLIST
  rm $PLIST
}

main() {
  if [ "$opt_uninstall" = 1 ]; then
    uninstall_plist
  else
    install_plist
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvu" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    u)
      uninstall_plist=1
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

