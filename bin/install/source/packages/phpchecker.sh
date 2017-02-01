#!/bin/bash

opt_force=0

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  declare -A bins
  bzip2_installed=`php -i | grep -e 'bzip2' | grep enabled | wc -l`
  bins["phpunit"]=https://phar.phpunit.de/phpunit.phar
  bins["phpunit-skelgen"]=https://phar.phpunit.de/phpunit-skelgen.phar
  bins["php-cs-fixer"]=https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.0.0/php-cs-fixer.phar
  bins["phpcs"]=https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
  bins["phploc"]=https://phar.phpunit.de/phploc.phar
  bins["phpdcd"]=https://phar.phpunit.de/phpdcd.phar
  bins["phpcpd"]=https://phar.phpunit.de/phpcpd.phar
  bins["phpsa"]=https://github.com/ovr/phpsa/releases/download/0.6.2/phpsa.phar
  bins["php-nag"]=https://github.com/algo13/php-nag/releases/download/0.0.1-bata2/phpnag.phar
  bins["phpmig"]=https://github.com/monque/PHP-Migration/releases/download/v0.2.2/phpmig.phar
  # bins[""]=
  if [ $bzip2_installed -eq 0 ]; then
    bins["phpmd"]=http://static.phpmd.org/php/latest/phpmd.phar
  fi
  [ ! -e ~/.bin/ ] && mkdir -p ~/.bin/
  for bin in "${!bins[@]}"; do
    [ "$opt_force" = 1 -a -e ~/.bin/$bin ] && rm ~/.bin/$bin
    [ ! -x ~/.bin/$bin ] && curl -Lo ~/.bin/$bin ${bins[$bin]} \
      && [ ! -x ~/.bin/$bin ] && chmod +x ~/.bin/$bin \
      && echo "installed $bin"
  done

  if [ $bzip2_installed -eq 0 ]; then
    echo "not found : bz2 extension..."
  fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvf" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
    f)
      opt_force=1
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

