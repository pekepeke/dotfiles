#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  caveats
  exit 1
}

caveats() {
  cat <<EOM

### run daemon

$ ponyd serve --listen-interface=127.0.0.1

### setup your project

platform :ios, '5.0'
pod 'PonyDebugger', '~> 0.4.0'


PDDebugger *debugger = [PDDebugger defaultInstance];
[debugger autoConnect]; // via bonjour
[debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
[debugger enableNetworkTrafficDebugging];
[debugger enableCoreDataDebugging];
[debugger enableViewHierarchyDebugging];
[debugger enableRemoteLogging];

### official url

https://github.com/square/PonyDebugger

EOM

}

main() {
  curl -sk https://cloud.github.com/downloads/square/PonyDebugger/bootstrap-ponyd.py | \
    python - --ponyd-symlink=/usr/local/bin/ponyd ~/Library/PonyDebugger

  caveats
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

