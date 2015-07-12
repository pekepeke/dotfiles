#!/bin/bash

git clone https://github.com/zimbatm/direnv.git ~/.direnv
make
DESTDIR=$HOME/.direnv make install

