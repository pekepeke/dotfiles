  // grunt.loadNpmTasks('grunt-contrib-imagemin');
  imagemin: {
    dist: {
      options: {
        optimizationLevel: 0,
        interlced : false,
        progressive : false,
        pngquant : false,
      },
      files: [{
        expand: true,
        cwd: 'src/images/',
        src: ['**/*.{png,jpg,gif}'],
        dest: 'public/images/'
      }]
    }
  },

