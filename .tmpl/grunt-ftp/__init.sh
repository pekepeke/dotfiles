#!/bin/bash

[ ! -e package.json ] && npm init
npm install grunt-ftp-deploy --save-dev

cat <<'EOM'
### Add below codes to your Gruntfile.js

var ftpSettings = {
  auth : {
    host: '',
    port: 21,
    authKey: 'this_domain'
  },
  src : ".",
  dest : "/public_html/",
  exclusions: ['**/.DS_Store', '**/Thumbs.db', '.git', '.svn', '.hg']
};


  grunt.initConfig({
    'ftp-deploy': {
      build: ftpSettings
    },
  });

  grunt.loadNpmTasks('grunt-ftp-deploy');

EOM
