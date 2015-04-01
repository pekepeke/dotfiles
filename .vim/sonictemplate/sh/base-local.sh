#!/bin/bash

cwd=$(pwd)
scriptdir=$(cd $(dirname $0)/;pwd)
localdir=$scriptdir/,local
root=$scriptdir/

trace() {
  echo "$@"
  "$@"
}

cd $localdir
for f in $(find . -type f); do
  [ $(basename $f) = ".DS_Store" ] && continue
  cd $root
  trace cp $localdir/$f $root/$f
  trace git update-index --assume-unchanged $root/$f
done

