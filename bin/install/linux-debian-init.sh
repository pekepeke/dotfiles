#!/bin/bash

PACKAGES="aptitude openssh-server ethtool build-essential screen tmux zsh tig"
PACKAGES="$PACKAGES git-core subversion libssl-dev curl bison"
PACKAGES="$PACKAGES libreadline-dev libxml2-dev libxslt-dev"
PACKAGES="$PACKAGES bison-doc"
PACKAGES="$PACKAGES sqlite3 autoconf automake libtool"
# PACKAGES="$PACKAGES ruby ruby-dev ri perl-doc "
PACKAGES="$PACKAGES mysqltuner percona-toolkit"
# PACKAGES="$PACKAGES samba samba-client"
# PACKAGES="$PACKAGES mysql-server"
PACKAGES="$PACKAGES snmp snmpd snmptt"
PACKAGES="$PACKAGES librrds-perl libsnmp-perl"
PACKAGES="$PACKAGES ruby-dev python3-dev libperl-dev lua5.4 luajit"
PACKAGES="$PACKAGES bat eza fzf zoxide git-delta ripgrep fd-find jq"
PACKAGES="$PACKAGES editorconfig exuberant-ctags"
# PACKAGES="$PACKAGES vim cvs ttf-inconsolata libncurses5-dev maatkit  zlib1g-deb"
# PACKAGES="$PACKAGES "

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  # sudo apt-get install --no-install-recommends -y $PACKAGES
  sudo apt-get install -y $PACKAGES

  # mkdir ~/setup-init
  # cd ~/setup-init
  # for mozc
  # wget -q http://download.opensuse.org/repositories/home:/sawaa/xUbuntu_10.04/Release.key -O- | sudo apt-key add -
  # sudo sh -c 'echo "deb http://download.opensuse.org/repositories/home:/sawaa/xUbuntu_10.04 ./" > /etc/apt/sources.list.d/ikoinoba.list'
  # for java
  # sudo add-apt-repository "deb http://archive.canonical.com/ lucid partner"
  # sudo apt-get update

  # sudo apt-get install ibus-mozc

  # sudo aptitude install sun-java6-jdk
  # sudo aptitude install freemind netbeans eclipse

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

