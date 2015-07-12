#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

main() {
  [ ! -e ~/Documents/Processing/tools ] && mkdir ~/Documents/Processing/tools
  cd ~/Documents/Processing/tools
  if [ ! -e ProcessingJS ]; then
    git clone https://github.com/fjenett/processingjstool.git ProcessingJS
  fi
  #if curl -O https://raw.github.com/processing-js/processing-js/master/processing.js ; then
  local latest_ver=$(curl http://processingjs.org/download/ | grep -e 'processing-[0-9\.]*\.min\.js' | perl -ne '$_ =~ m/(processing-[0-9\.]*\.min\.js)/; print $1')
  if curl https://github.com/downloads/processing-js/processing-js/$latest_ver > processing.js; then
    echo "update processing.js - $latest_ver"
    cp processing.js ProcessingJS/templates/only_js/
    cp processing.js ProcessingJS/templates/template_js/
  else
    echo "fail update processing.js - $latest_ver"
  fi
  [ -e processing.js ] && rm processing.js

  if [ ! -e BezierTool ]; then
    wget http://www.drifkin.net/beziereditor/beziereditor-latest.zip
    unzip beziereditor-latest.zip
  fi

  if [ ! -e G4PTool ]; then
    wget http://g4p-gui-builder.googlecode.com/files/G4PTool-1.1.1.zip
    unzip G4PTool-1.1.1.zip  -d G4PTool
  fi

  if [ ! -e ObliqueTool ]; then
    wget https://github.com/downloads/sansumbrella/Processing-ObliqueStrategies/ObliqueTool-v1.0.1.zip
    unzip ObliqueTool-v1.0.1.zip
  fi

  if [ ! -e Doodle ]; then
    wget http://github.com/fjenett/doodle/zipball/latest -O doodle.zip
    unzip doodle.zip
    mv fjenett-doodle-* Doodle
  fi

  if [ ! -e ColorSelectorPlusTool ]; then
    wget http://color-selector-plus.googlecode.com/files/ColorSelectorPlusTool-latest.zip
    unzip ColorSelectorPlusTool-latest.zip
  fi

  if [ ! -e SimpleLiveCoding ]; then
    wget http://github.com/fjenett/simplelivecoding/zipball/latest -O slc.zip
    unzip slc.zip
    mv fjenett-simplelivecoding-* SimpleLiveCoding
  fi

  if [ ! TimelineTool ]; then
    wget http://www.drifkin.net/timeline/timeline-a003.zip
    unzip timeline-a003.zip
    mv timeline-a003/TimelineTool ./
    mv timeline-a003/TimelineLibrary/library ./
    mv timeline-a003 trash
  fi

  mkdir trash
  mv *.zip *.txt trash
  mv __MACOSX trash 
  open .
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

