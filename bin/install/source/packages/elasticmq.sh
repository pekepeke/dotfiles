#!/bin/bash

INSTALLED_DIR=~/.local/bin
DOWNLOAD_URL="https://s3-eu-west-1.amazonaws.com/softwaremill-public/elasticmq-server-0.8.2.jar"
BINPATH="${INSTALLED_DIR}/elasticmq-server"

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

bin_script() {
  cat <<EOM
#!/bin/sh

java -jar "${BINPATH}.jar" "$@" &
EOM

}

main() {
  [ ! -e $INSTALLED_DIR ] && mkdir -p $INSTALLED_DIR
  if [ ! -e "${BINPATH}.jar" ]; then
    curl -o "${BINPATH}.jar" -L "${DOWNLOAD_URL}"
  fi
  bin_script > "${BINPATH}"
  chmod a+x "${BINPATH}"
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

