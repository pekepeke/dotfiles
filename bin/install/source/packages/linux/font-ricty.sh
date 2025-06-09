#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

executable() {
  which $1 > /dev/null 2>&1
  return $?
}

main() {
  # install Ricty
  # [ ! -e ~/.tmp ] && mkdir ~/.tmp
  cd /tmp
  git clone --depth=1 https://github.com/yascentur/Ricty.git
  cd Ricty

  if ! executable fontforge ; then
    if executable aptitude ; then
      #sudo aptitude install ttf-inconsolata
      sudo aptitude install fontforge
    else
      echo fontforge is required
      exit 1
    fi
  fi

  local ricty_ver=20111002
  wget "http://sourceforge.jp/frs/redir.php?m=keihanna&f=%2Fmix-mplus-ipa%2F53389%2Fmigu-1m-${ricty_ver}.zip"
  unzip migu-1m-${ricty_ver}.zip
  mv migu-1m-${ricty_ver}/migu-1m-*.ttf ./
  curl -LO http://levien.com/type/myfonts/Inconsolata.otf
  sh ricty_generator.sh Inconsolata.otf migu-1m-regular.ttf migu-1m-bold.ttf

  if executable fc-cache ; then
    [ ! -e ~/.local/share/fonts/ ] && mkdir -p ~/.local/share/fonts
    cp -f Ricty*.ttf ~/.local/share/fonts/
    fc-cache -vf
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

