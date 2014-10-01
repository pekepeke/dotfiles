#!/bin/bash

npm init
npm install connect --save
npm install serve-static --save
npm install coffee-script --save
npm install json --save-dev

cat package.json | ./node_modules/.bin/json -e 'this.port = 48080' > .package.json
if [ -e .package.json ]; then
  cp .package.json package.json
  rm .package.json
fi
