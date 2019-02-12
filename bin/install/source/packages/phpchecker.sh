#!/usr/bin/env bash

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
  phpast_installed=0
  bzip2_installed=`php -i | grep -e 'bzip2' | grep enabled | wc -l`
  php -r 'exit( (int)!function_exists("bzcompress") );' && phpbzip2_installed=1
  php -r 'exit( (int)!class_exists("ast\\Node") );' && phpast_installed=1
  bins["phpunit"]=https://phar.phpunit.de/phpunit.phar
  bins["phpunit-skelgen"]=https://phar.phpunit.de/phpunit-skelgen.phar
  # https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases
  bins["php-cs-fixer"]=https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.14.0/php-cs-fixer.phar
  bins["phpcs"]=https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
  bins["phpcbf"]=https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
  bins["phploc"]=https://phar.phpunit.de/phploc.phar
  bins["phpdcd"]=https://phar.phpunit.de/phpdcd.phar
  bins["phpcpd"]=https://phar.phpunit.de/phpcpd.phar
  bins["phpsa"]=https://github.com/ovr/phpsa/releases/download/0.6.2/phpsa.phar
  bins["phpstan"]=https://github.com/phpstan/phpstan/releases/download/0.11.1/phpstan.phar

  # bins["php-nag"]=https://github.com/algo13/php-nag/releases/download/0.0.1-bata2/phpnag.phar
  # bins["phpmig"]=https://github.com/monque/PHP-Migration/releases/download/v0.2.2/phpmig.phar

  # bins[""]=
  if [ $phpbzip2_installed -eq 1 ]; then
    bins["phpmd"]=http://static.phpmd.org/php/latest/phpmd.phar
  fi
  if [ $phpast_installed -eq 1 ]; then
    # https://github.com/etsy/phan/releases
    bins["phan"]=https://github.com/etsy/phan/releases/download/1.2.1/phan.phar
  fi
  [ ! -e ~/.bin/ ] && mkdir -p ~/.bin/
  for bin in "${!bins[@]}"; do
    [ "$opt_force" = 1 -a -e ~/.bin/$bin ] && rm ~/.bin/$bin
    [ ! -x ~/.bin/$bin ] && curl -Lo ~/.bin/$bin ${bins[$bin]} \
      && [ ! -x ~/.bin/$bin ] && chmod +x ~/.bin/$bin \
      && echo "installed $bin"
  done

  if ! which composer >/dev/null 2>&1; then
    curl -sS https://getcomposer.org/installer | php
    chmod +x composer.phar
    mv composer.phar ~/.bin/composer
  fi
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

