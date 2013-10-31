  # grunt.loadNpmTasks 'grunt-contrib-uglify'
  uglify:
    dev:
      options:
        mangle: false
        compress: false
        preserveComments: 'all'
        beautify: true

      files: [
        'public/js/vendor.js': [
          'src/lib/**/*.js'
        ],
          expand: true
          src: '**/*.js'
          dest: 'public/js'
          cwd: 'src/js'
      ]
    dist:
      options:
        mangle: true
        compress: true
      files: [
        'public/js/vendor.js': [
          'src/lib/**/*.js'
        ],
          expand: true
          src: '**/*.js'
          dest: 'public/js'
          cwd: 'src/js'
      ]

