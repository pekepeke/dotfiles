  // grunt.loadNpmTasks('grunt-contrib-jshint')
  jshint: {
    options: {
      jshintrc: '.jshintrc'
    },
    all: ['src/js/**/*.js', '!src/js/*.min.js']
  },

