  # grunt.loadNpmTasks 'grunt-contrib-connect'
  connect:
    livereload:
      options:
        hostname : "0.0.0.0"
        port: 9001
        middleware: (connect, options) ->
          return [folderMount(connect, "./")]


