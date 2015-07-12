#!/bin/bash

cd $HOME/.direnv
git pull
make clean
make
DESTDIR=$HOME/.direnv make install
