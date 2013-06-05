#!/bin/bash

[ ! -e package.json ] && npm init
npm install grunt grunt-regarde grunt-contrib-connect grunt-contrib-livereload --save-dev
