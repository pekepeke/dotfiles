module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
    watch:
      files: ['coffee/**/*.coffee'],
      tasks: ['coffee','uglify']

    coffee:
      compile:
        options:
          sourceMap: true
        files: [
            expand: true,
            cwd: 'coffee/',
            src: ['**/*.coffee'],
            dest: 'js/',
            ext: '.js'
        ]
    uglify:
      compress_target:
        options:
          sourceMap: (fileName) ->
            fileName.replace /\.js$/, '.js.map'
        files: [
            expand: true,
            cwd: 'js/',
            src: ['**/*.js'],
            dest: 'compress/',
            ext: '.js'
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
