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
PACKAGES="$PACKAGES postgresql-client mongodb-clients"

PACKAGES="$PACKAGES xclip wl-clipboard wofi trash-cli"
PACKAGES="$PACKAGES vlc "

# for gvim
PACKAGES="$PACKAGES autopoint cscope debhelper debugedit dh-autoreconf dh-strip-nondeterminism"
PACKAGES="$PACKAGES docbook-dsssl docbook-utils dwz fonts-lmodern gettext gir1.2-freedesktop-dev"
PACKAGES="$PACKAGES gir1.2-glib-2.0-dev intltool-debian libacl1-dev libapache-pom-java"
PACKAGES="$PACKAGES libarchive-zip-perl libatk-bridge2.0-dev libatk1.0-dev libatspi2.0-dev"
PACKAGES="$PACKAGES libattr1-dev libblkid-dev libbrotli-dev libbz2-dev libcairo2-dev"
PACKAGES="$PACKAGES libcanberra-dev libcommons-logging-java libcommons-parent-java libdatrie-dev"
PACKAGES="$PACKAGES libdbus-1-dev libdebhelper-perl libdeflate-dev libegl-dev libegl1-mesa-dev"
PACKAGES="$PACKAGES libepoxy-dev libffi-dev libfile-stripnondeterminism-perl libfontbox-java"
PACKAGES="$PACKAGES libfontconfig-dev libfreetype-dev libfribidi-dev libgdk-pixbuf-2.0-dev"
PACKAGES="$PACKAGES libgirepository-2.0-0 libgl-dev libgles-dev libgles1 libglib2.0-dev"
PACKAGES="$PACKAGES libglib2.0-dev-bin libglvnd-core-dev libglvnd-dev libglx-dev libgpm-dev"
PACKAGES="$PACKAGES libgraphite2-dev libgtk-3-dev libharfbuzz-cairo0 libharfbuzz-dev"
PACKAGES="$PACKAGES libharfbuzz-subset0 libice-dev libjbig-dev libjpeg-dev libjpeg-turbo8-dev"
PACKAGES="$PACKAGES libjpeg8-dev liblerc-dev liblua5.1-0 liblua5.1-0-dev liblzma-dev"
PACKAGES="$PACKAGES libmotif-common libmotif-dev libmount-dev libmrm4 libopengl-dev libosp5"
PACKAGES="$PACKAGES libostyle1t64 libpango1.0-dev libpcre2-dev libpdfbox-java libpixman-1-dev"
PACKAGES="$PACKAGES libpkgconf3 libpng-dev libpotrace0 libptexenc1 libpthread-stubs0-dev"
PACKAGES="$PACKAGES libselinux1-dev libsepol-dev libsgmls-perl libsharpyuv-dev libsm-dev"
PACKAGES="$PACKAGES libsodium-dev libsub-override-perl libteckit0 libtexlua53-5 libthai-dev"
PACKAGES="$PACKAGES libtiff-dev libtiffxx6 libtool-bin libuil4 libwayland-bin libwayland-dev"
PACKAGES="$PACKAGES libwebp-dev libwebpdecoder3 libx11-dev libxau-dev libxcb-render0-dev"
PACKAGES="$PACKAGES libxcb-shm0-dev libxcb1-dev libxcomposite-dev libxcursor-dev libxdamage-dev"
PACKAGES="$PACKAGES libxdmcp-dev libxext-dev libxfixes-dev libxft-dev libxi-dev libxinerama-dev"
PACKAGES="$PACKAGES libxkbcommon-dev libxm4 libxrandr-dev libxrender-dev libxt-dev libxtst-dev"
PACKAGES="$PACKAGES libzstd-dev libzzip-0-13t64 lua5.1 lynx lynx-common openjade opensp"
PACKAGES="$PACKAGES pango1.0-tools pdf2svg pkgconf pkgconf-bin po-debconf preview-latex-style"
PACKAGES="$PACKAGES python3-packaging sgmlspl t1utils tcl-dev tcl8.6-dev teckit tex-common"
PACKAGES="$PACKAGES texlive-base texlive-binaries texlive-fonts-recommended"
PACKAGES="$PACKAGES texlive-formats-extra texlive-latex-base texlive-latex-extra"
PACKAGES="$PACKAGES texlive-latex-recommended texlive-pictures texlive-plain-generic"
PACKAGES="$PACKAGES texlive-xetex tipa uil uuid-dev wayland-protocols x11proto-dev"
PACKAGES="$PACKAGES xorg-sgml-doctools xtrans-dev"

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

