#!/bin/bash

BINDIR=~/.local/bin
DOCROOT=~/.local/share/vim/docs

WGET_HTMLDOC=~/.vim/bundle/vim-ref-html/tool/wget-aptana-html.sh
WGET_HTML5DOC=~/.vim/bundle/vim-ref-html5/tool/wget-html5jp.sh
PY_HTML5DOC_SCRAPE=~/.vim/bundle/vim-ref-html5/tool/scrape.py
WGET_JSCORE=~/.vim/bundle/vim-ref-jscore/tool/wget-aptana.sh

opt_force=0
#. $(dirname $0)/functions.sh
usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

is_perlbrew() {
  if [[ $(which perl) =~ $HOME ]]; then
    return 0
  fi
  return 1
}

get_latest_refe_url() {
  base="http://doc.ruby-lang.org/archives/"
  dir=$(curl -s $base | grep "^<a href" | sort -r | head -1 | perl -ne 'print $1 if ($_ =~ /href="(.*)"/)')
  name=$(curl -s $base$dir | grep "tar.gz" | sort -r | perl -ne 'print $1 if ($_ =~ /href="(.*)"/)')
  echo $base$dir$name
}

install_refe() {
  cd $DOCROOT
  wget $(get_latest_refe_url)
  tar zxvf ruby-refm-*.tar.gz
  rm -f ruby-refm-*.tar.gz
  tee $BINDIR/refe <<EOM
#!/bin/sh

LMANDIR=$DOCROOT
for REFE in \$(ls -dt \$LMANDIR/ruby-refm-* 2>/dev/null) ; do
  for CMD in \$(ls -r \$REFE/refe-* | awk '\$1 !~ /\.cmd/ {print \$1}') ; do
    \$CMD \$*
    exit \$?
  done
done
EOM
  chmod +x $BINDIR/refe
}

install_phpman() {
  cd $DOCROOT
  # wget http://jp2.php.net/get/php_manual_ja.tar.gz/from/jp.php.net/mirror
  wget -O php_manual_ja.tar.gz http://jp2.php.net/get/php_manual_ja.tar.gz/from/jp1.php.net/mirror
  tar zxf php_manual_ja.tar.gz && mv php-chunked-xhtml/ $DOCROOT/phpman/
  rm -f php_manual_ja.tar.gz
}

install_cppref() {
  cd $DOCROOT
  [ ! -e cppref ] && git clone --depth=1 https://github.com/kazuho/cppref.git
  cd cppref
  git pull
  $CPANM File::ShareDir HTML::TreeBuilder Web::Scraper File::Slurp Text::MicroTemplate
  sed -i "" 's/^\^doc/#^doc/' MANIFEST.SKIP
  perl Makefile.pl && make
  ln -s $(pwd)/cppref $BINDIR
}

install_jsref() {
  cd $DOCROOT
  [ ! -e jsref ] && git clone --depth=1 https://github.com/walf443/jsref.git
  cd jsref
  git pull
  $CPANM File::ShareDir HTML::TreeBuilder Web::Scraper File::Slurp Text::MicroTemplate
  sed -i "" 's/^\^doc/#^doc/' MANIFEST.SKIP
  perl Makefile.pl && make
  ln -s $(pwd)/jsref $BINDIR
}

install_jqapi() {
  cd $DOCROOT
  local FILE_NAME=jqapi
  [ -e $FILE_NAME.zip ] && rm $FILE_NAME.zip
  [ -e $FILE_NAME ] && rm -rf $FILE_NAME
  wget -o http://jqapi.com/$FILE_NAME.zip
  unzip $FILE_NAME.zip -d $DOCROOT/jqapi-latest
}

install_nodejs_src() {
  cd $DOCROOT
  [ ! -e nodejs ]  && git clone --depth=1 https://github.com/joyent/node.git nodejs
  cd nodejs
  git pull
}

install_timobileref() {
  cd $DOCROOT
  [ ! -e timobileref ] && git clone --depth=1 https://github.com/pekepeke/timobileref.git
  cd timobileref
  # curl -LO http://xrl.us/cpanm
  # chmod +x cpanm
  # # ./cpanm -l extlib/ --installdeps .
  # ./cpanm -l extlib/ Module::Install File::ShareDir
  git pull
  perl Makefile.PL
  make
  ln -s $(pwd)/timobileref $BINDIR
}

install_tidesktopref() {
  cd $DOCROOT
  [ ! -e tidesktopref ] && git clone --depth=1 https://github.com/pekepeke/tidesktopref.git
  cd tidesktopref
  git pull
  perl Makefile.PL
  make
  ln -s $(pwd)/tidesktopref $BINDIR
}

install_htmldoc() {
  mkdir -p $DOCROOT/htmldoc
  cd $DOCROOT/htmldoc
  if [ -e $WGET_HTMLDOC ]; then
    [ -e www.aptana.com ] && rm -rf www.aptana.com
    sh $WGET_HTMLDOC
  fi
  # $DOCROOT/htmldoc/www.aptana.com/reference/html/api/
}
install_html5doc() {
  pip install beautifulsoup
  mkdir -p $DOCROOT/html5doc
  cd $DOCROOT/html5doc
  if [ -e $WGET_HTML5DOC ]; then
    [ -e www.html5.jp ] && rm -rf www.html5.jp
    sh $WGET_HTML5DOC
    python $PY_HTML5DOC_SCRAPE
  fi
  # $DOCROOT/htmldoc/dist
}

install_jscore() {
  mkdir -p $DOCROOT/jscore
  cd $DOCROOT/jscore
  if [ -e $WGET_JSCORE ]; then
    [ -e www.aptana.com ] && rm -rf www.aptana.com
    sh $WGET_JSCORE
  fi
  # $DOCROOT/jscore/www.aptana.com/reference/html/api
}

main() {
  CPANM="cpanm"
  # if ! is_perlbrew; then
  #   CPANM="sudo cpanm"
  # fi
  [ ! -e $DOCROOT ] && mkdir -p $DOCROOT
  [ ! -e $BINDIR ] && mkdir -p $BINDIR
  cd $DOCROOT
  # if [ $opt_force -eq 1 -o ! -e "$(which refe)" ]; then
  #   install_refe
  # else
  #   echo "refe is installed."
  # fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/phpman ];then
    install_phpman
  else
    echo "phpman is installed."
  fi
  if [ $opt_force -eq 1 -o ! -e $BINDIR/cppref ];then
    install_cppref
  else
    echo "cppref is installed."
  fi
  if [ $opt_force -eq 1 -o ! -e $BINDIR/jsref ]; then
    install_jsref
  else
    echo "jsref is installed."
  fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/jqapi-latest ]; then
    install_jqapi
  else
    echo "jqapi-latest is installed."
  fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/timobileref ]; then
    install_timobileref
  else
    echo "timobileref is installed"
  fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/tidesktopref ]; then
    install_tidesktopref
  else
    echo "tidesktopref is installed"
  fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/htmldoc ]; then
    install_htmldoc
  else
    echo "htmldoc is installed"
  fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/html5doc ]; then
    install_html5doc
  else
    echo "html5doc is installed"
  fi
  if [ $opt_force -eq 1 -o ! -e $DOCROOT/jscore ]; then
    install_jscore
  else
    echo "jscore is installed"
  fi

}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hvf" opt; do
  case $opt in
    h)
      usage ;;
    f)
      opt_force=1 ;;
    v) ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

