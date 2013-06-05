#!/bin/bash

[ ! -e package.json ] && npm init
npm install grunt --save-dev
npm install grunt-coffee -save-dev
npm install grunt-contrib-uglify -save-dev
npm install grunt-contrib-watch -save-dev

mkdir coffee ; mkdir js ; mkdir compress

