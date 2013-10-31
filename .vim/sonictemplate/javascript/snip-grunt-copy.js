  // grunt.loadNpmTasks('grunt-contrib-copy');
  copy: {
    main: {
      files: [
        // {
        //   expand: true,
        //   cwd: 'components/formalize/assets/css/',
        //   src: '_formalize.scss',
        //   dest: 'sass/partials/vendor/',
        //   filter: 'isFile',
        //   flatten: true
        // },
        {
          expand: true,
          cwd: 'src/resources/',
          src: '**',
          dest: 'public/resources/',
          filter: 'isFile',
          flatten: true
        }
      ]
    }
  },
