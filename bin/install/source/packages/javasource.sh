#!/bin/bash

ROOT=$HOME/.java-dev
SRC_INST_DIR=$ROOT/src
TAG_INST_DIR=$ROOT/tags
JAR_INST_DIR=$ROOT/jar

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

install_java_source() {
  cd $SRC_INST_DIR
  #http://download.java.net/jdk6/source/
  # ver=$(ls jdk-*.jar | perl -ne 'print $1 if /jdk-([\w\d]*)-.*/')
  # if [ x$ver = x ]; then
  #   wget http://www.java.net/download/jdk6/6u23/promoted/b05/jdk-6u23-fcs-src-b05-jrl-12_nov_2010.jar
  #   ver=$(ls jdk-*.jar | perl -ne 'print $1 if /jdk-([\w\d]*)-.*/')
  # fi
  # if [ x$ver != x -a ! -e java-$ver ]; then
  #   unzip jdk-*.jar
  #   unzip jdk*.jar -d java-$ver
  # fi
  if [ ! -e jdk7u6 ]; then
    hg clone http://hg.openjdk.java.net/jdk7u/jdk7u6
  else
    cd jdk7u6
    hg pull
    cd ..
  fi
}

install_android_source() {
  cd $SRC_INST_DIR
  if [ ! -e android ] ; then
    # git clone --depth 1 git://android.git.kernel.org/platform/frameworks/base.git android-base
    git clone --depth 1  https://android.googlesource.com/device/ti/panda android
  else
    cd android
    git pull
    cd ..
  fi
}

create_ctags() {

  cd $SRC_INST_DIR
  for f in $(ls); do
    echo ctags -f $TAG_INST_DIR/$f -R $SRC_INST_DIR/$f
    ctags -f $TAG_INST_DIR/$f -R $SRC_INST_DIR/$f
  done

}

main() {
  [ ! -d $SRC_INST_DIR ] && mkdir -p $SRC_INST_DIR
  [ ! -d $TAG_INST_DIR ] && mkdir -p $TAG_INST_DIR
  [ ! -d $JAR_INST_DIR ] && mkdir -p $JAR_INST_DIR

  install_java_source
  install_android_source

  create_ctags

  cat <<EOM


#
# please download jars => ~/.java-jars/jars
#

mysql - http://dev.mysql.com/downloads/connector/j/
postgres - http://jdbc.postgresql.org/download.html
sqlite - https://bitbucket.org/xerial/sqlite-jdbc
EOM

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

