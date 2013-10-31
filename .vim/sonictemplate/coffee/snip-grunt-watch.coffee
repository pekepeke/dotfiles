# grunt.loadNpmTasks 'grunt-contrib-watch'
  watch:
    scripts:
      files: ["**/*.js"]
      tasks: ['jshint']
    livereload:
      options: true
      files: ["**/*"]


