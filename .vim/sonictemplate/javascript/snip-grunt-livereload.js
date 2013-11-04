var path = require('path');
var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;
var folderMount = function folderMount(connect, point) {
    return connect.static(path.resolve(point));
};

module.exports = function(grunt) {
  grunt.initConfig({
    connect: {
      server: {
        options: {
          port: 9001,
          middleware: function(connect, options) {
            return [lrSnippet, folderMount(connect, '.')];
          }
        }
      }
    }
  });
};
