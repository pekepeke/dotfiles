#!/bin/bash

gulpfile() {
  cat <<EOM
gulp       = require 'gulp'
util       = require 'gulp-util'
coffee     = require 'gulp-coffee'
sass       = require 'gulp-sass'
slim       = require 'gulp-slim'
plumber    = require 'gulp-plumber'

APP_FILE = './src/app.coffee'
COFFEE_FILES = './src/coffee/**/*.coffee'
SASS_FILES = './src/sass/**/*.sass'
SLIM_FILES = './src/slim/**/*.slim'
IMAGE_FILES = './src/images/**/*.{jpg,jpeg,png,gif}'

gulp.task 'coffee', ->
  gulp.src APP_FILE
    .pipe plumber()
    .pipe coffee bare: true
    .on 'error', util.log
    .pipe gulp.dest './dist/'

gulp.task 'coffee', ->
  gulp.src COFFEE_FILES
    .pipe plumber()
    .pipe coffee bare: true
    .on 'error', util.log
    .pipe gulp.dest './dist/js'

gulp.task 'watch-coffee', ->
  gulp.watch COFFEE_FILES, ['coffee']

gulp.task 'sass', ->
  gulp.src SASS_FILES
    .pipe plumber()
    .pipe sass indentedSyntax: true
    .pipe gulp.dest './dist/css'

gulp.task 'watch-sass', ->
  gulp.watch SASS_FILES, ['sass']

gulp.task 'slim', ->
  gulp.src SLIM_FILES
    .pipe plumber()
    .pipe slim pretty: true
    .pipe gulp.dest './dist/html'

gulp.task 'watch-slim', ->
  gulp.watch SLIM_FILES, ['slim']

gulp.task 'images', ->
  gulp.src IMAGE_FILES
    .pipe gulp.dest './dist/images'

gulp.task 'watch-images', ->
  gulp.watch IMAGE_FILES, ['images']

gulp.task 'watch', ['watch-coffee', 'watch-sass', 'watch-slim', 'watch-images']
gulp.task 'default', ['coffee', 'sass', 'slim', 'images']
EOM
}

app_coffee() {
  cat <<EOM
app = require 'app'
BrowserWindow = require 'browser-window'
require('crash-reporter').start()

main_window = null

app.on('window-all-closed', () ->
  if process.platform isnt 'darwin'
    app.quit
)
app.on('ready', () ->
  main_win = new BrowserWindow({ width: 800, height: 600 })
    main_window.loadUrl('file://#{ __dirname }/dist/html/index.html')
  )
  main_win.on('closed', () -> main_win = null)
EOM

}

initialize() {
  mkdir -p src/coffee
  mkdir -p src/sass
  mkdir -p src/slim
}

npm install --save-dev gulp coffee-script gulp-coffee gulp-plumber gulp-sass gulp-slim gulp-util
