#!/bin/bash

INSTALL_DIR=~/Sites/tools/
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}


install_from_github() {
  cd $INSTALL_DIR
  local REPO=$1
  local NAME=$2
  [ x"$NAME" = x ] && NAME=$(basename $REPO)

  # echo $REPO $NAME
  [ ! -e $NAME ] && git clone --depth=1 https://github.com/${REPO}
  cd $NAME
  git reset --hard HEAD
  git pull

}

install_from_svn() {
  cd $INSTALL_DIR
  local REPO=$1
  local NAME=$2
  [ x"$NAME" = x ] && NAME=$(basename $REPO)
  svn co --trust-server-cert --non-interactive $REPO $NAME
}

install_composer() {
  if ! which composer ; then
    curl -sS https://getcomposer.org/installer | php -d 'detect_unicode=Off'
    COMPOSER="php -d 'detect_unicode=Off' composer.phar"
  else
    COMPOSER="composer"
  fi
  $COMPOSER install
}

install_mdtree() {
  cd $INSTALL_DIR
  if [ ! -e "$INSTALL_DIR/mdtree" ]; then
    mkdir "$INSTALL_DIR/mdtree"
  fi
  cd mdtree
  if !which composer ; then
    curl -sS https://getcomposer.org/installer | php -d 'detect_unicode=Off'
    COMPOSER="php -d 'detect_unicode=Off' composer.phar"
  else
    COMPOSER="composer"
  fi
  if [ ! -e composer.json ]; then
    echo '{ "require": { "hollodotme/treemdown": "~1.0" } }' > composer.json
  fi
  install_composer
  sed -i 's!utf8_decode( $file_encoder->getFileContents() )!$file_encoder->getFileContents()!' vendor/hollodotme/treemdown/dist/Rendering/HTMLPage/Body.php
  sed -i 's!loadHTML( $markdown )!loadHTML( mb_convert_encoding($markdown, "HTML-ENTITIES", "UTF-8") )!' vendor/hollodotme/treemdown/dist/Rendering/HTMLPage/Body.php

}

mdtree_index() {
  cat <<EOM
<?php

require dirname(__FILE__) . "/vendor/autoload.php";
use hollodotme\TreeMDown\TreeMDown;

date_default_timezone_set('Asia/Tokyo');
if (function_exists('mb_language')) {
  mb_language('Japanese');
  ini_set('mbstring.detect_order', 'auto');
  ini_set('mbstring.http_input'  , 'pass');
  ini_set('mbstring.http_output' , 'pass');
  ini_set('mbstring.internal_encoding', 'UTF-8');
  ini_set('mbstring.script_encoding'  , 'UTF-8');
  ini_set('mbstring.encoding_translation', 'none');
  ini_set('mbstring.substitute_character', 'none');
  ini_set('mbstring.strict_detection', 'Off');
  mb_regex_encoding('UTF-8');
}

\$treemdown = new TreeMDown( '$HOME/memos/' );
\$treemdown->setProjectName('$USER markdowns');
\$treemdown->setShortDescription('$USER markdowns');
\$treemdown->setCompanyName('$USER');
#\$treemdown->showEmptyFolders();
\$treemdown->hideEmptyFolders();
\$treemdown->setDefaultFile('README.md');
#\$tmd->showFilenameSuffix();
#\$treemdown->hideFilenameSuffix();
\$treemdown->disablePrettyNames();
#\$treemdown->enablePrettyNames();
\$treemdown->setIncludePatterns( array( '*.md', '*.markdown', '*.txt') );
\$treemdown->setExcludePatterns( array( '.*' ) );
\$treemdown->display();
EOM

}

install_anemometer() {
  cd $INSTALL_DIR
  install_from_github box/Anemometer anemometer
  cd anemometer
  if [ ! -e anemometer ]; then
    mysql < install.sql
    # echo "grant ALL ON slow_query_log.* to 'anemometer'@'%' IDENTIFIED BY 'pass';" | mysql

    cat <<'EOM' > sync.sh
#!/bin/bash

# pt-query-digest --user=anemometer --password=pass \
# /var/lib/mysql/localhost-slow.log
pt-query-digest \
    --review h=localhost,D=slow_query_log,t=global_query_review \
    --history h=localhost,D=slow_query_log,t=global_query_review_history \
    --no-report --limit=0% \
    --filter=" \$event->{Bytes} = length(\$event->{arg}) and \$event->{hostname}=\"$HOSTNAME\"" \
    /usr/local/var/log/mysql/mysql-slowquery.log
EOM
  fi
}

# install_xxx() {
#   cd $INSTALL_DIR
# }

main() {
  [ ! -e $INSTALL_DIR ] && mkdir -p $INSTALL_DIR
  cd $INSTALL_DIR
  install_from_github meso-cacase/difff
  cd difff
  sed -ie 's!http://difff.jp/!index.cgi!' index.cgi
  cd ..
  install_from_github facebook/xhprof
  install_from_github pekepeke/cgiutils
  install_from_github jeremyckahn/stylie
  # install_from_github calvinlough/sqlbuddy

  cd "$INSTALL_DIR"
  cp cgiutils/utils/dirindex.php index.php

  install_from_github jmullan/apc-stats
  install_from_github jokkedk/webgrind
  install_from_github Self-Evident/OneFileCMS

  install_from_github vrana/adminer
  if [ -e "$INSTALL_DIR/adminer" ];then
    cd $INSTALL_DIR/adminer
    php compile.php
    mv -f adminer.php index.php
    cp -f designs/brade/adminer.css ./
  fi

  install_from_svn http://phpmemcacheadmin.googlecode.com/svn/trunk/ phpmemcacheadmin

  install_from_github ErikDubbelboer/phpRedisAdmin
  if [ -e "$INSTALL_DIR/phpRedisAdmin" ];then
    cd "$INSTALL_DIR/phpRedisAdmin"
    git submodule update --init
    install_composer
  fi

  install_from_github iwind/rockmongo
  cd $INSTALL_DIR
  [ ! -e rockmongo/app/plugins ] && git clone --depth 1 git://github.com/iwind/RockMongoPlugins.git rockmongo/app/plugins
  cd rockmongo/app/plugins && git pull

  install_mdtree
  # install_from_github sasanrose/phpredmin
  # mkdir phpredmin/logs
  # chmod 777 phpredmin/logs

  # install_from_github lagged/memcache.php memcache
  # if [ -e "$INSTALL_DIR/memcache" ];then
  #   cd "$INSTALL_DIR/memcache"
  #   cp -f etc/config.php etc/config.local.php
  #   sed -ie 's!</head>!<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.1/css/bootstrap.min.css"></link><link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.1/css/bootstrap-responsive.min.css"></link><style> .nav-tabs { padding:60px; } </style><script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.1/css/bootstrap.min.js"></script></head>!' src/display.functions.php
  # fi
  install_anemometer
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

