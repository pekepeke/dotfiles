  // grunt.loadNpmTasks('grunt-contrib-watch')
  watch : {
    scripts: {
      files: ["public/**/*.js"],
      tasks: ['jshint']
    },
    livereload: {
      options: true,
      files: ["public/**/*"]
    }
  },


