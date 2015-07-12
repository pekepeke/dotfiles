#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  cd /tmp
  curl -LO http://pkgs.fedoraproject.org/repo/pkgs/stardict-dic-ja/stardict-jmdict-en-ja-2.4.2.tar.bz2/e0f60d6acc4e3df6784805816b2e136f/stardict-jmdict-en-ja-2.4.2.tar.bz2
  curl -LO http://pkgs.fedoraproject.org/repo/pkgs/stardict-dic-ja/stardict-jmdict-ja-en-2.4.2.tar.bz2/2c574aef86a5d7bab45395d7e8ee7f6b/stardict-jmdict-ja-en-2.4.2.tar.bz2

  mkdir -p ~/.stardict/dic
  tar jxvf /tmp/stardict-jmdict-ja-en-2.4.2.tar.bz2 -C ~/.stardict/dic/
  tar jxvf /tmp/stardict-jmdict-en-ja-2.4.2.tar.bz2 -C ~/.stardict/dic/

  cd  ~/.stardict/dic
  curl -LO http://dl.babylon.com/info/glossaries/4E9/Babylon_Japanese_English_dicti.BGL
  curl -LO http://dl.babylon.com/info/glossaries/38B/Babylon_English_Japanese.BGL
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

