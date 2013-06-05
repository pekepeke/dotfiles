/*jshint strict: true, node : true, es5 : true */
'use strict';
var path = require('path');
var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;

var folderMount = function folderMount(connect, point) {
  return connect.static(path.resolve(point));
};

module.exports = function (grunt) {
  // Project configuration.
  grunt.initConfig({
    connect: {
      livereload: {
        options: {
          port: 9001,
          middleware: function(connect, options) {
            return [lrSnippet, folderMount(connect, '.')];
          }
        }
      }
    },
    regarde: {
      html: {
        files: '**/*.html',
        tasks: ['livereload']
      },
      css: {
        files: 'public/**/*.css',
        tasks: ['livereload']
      },
      javascript: {
        files: 'public/**/*.js',
        tasks: ['livereload']
      }
    }

  });

  grunt.loadNpmTasks('grunt-regarde');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-livereload');

  grunt.registerTask('default', ['livereload-start', 'connect', 'regarde']);
};
