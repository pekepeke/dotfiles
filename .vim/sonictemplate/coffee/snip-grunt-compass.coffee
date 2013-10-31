  # grunt.loadNpmTasks 'grunt-contrib-compass'
  compass:
    dev:
      options:
        environment: 'development'
        outputStyle: 'expanded'
        relativeAssets: true
        raw: 'line_numbers = :true\n'
        bundleExec: true
        httpPath: '/'
        cssDir: 'public/css'
        sassDir: 'src/sass'
        imagesDir: 'public/images'
        fontsDir: 'public/css/fonts'
        assetCacheBuster: 'none'
        require: [
          'sass-globbing'
        ]
    dist:
      options:
        environment: 'production'
        outputStyle: 'compact'
        force: true
        bundleExec: true
        httpPath: '/'
        cssDir: 'public/css'
        sassDir: 'src/sass'
        imagesDir: 'public/images'
        fontsDir: 'public/css/fonts'
        assetCacheBuster: 'none'
        require: [
          'sass-globbing'
        ]

