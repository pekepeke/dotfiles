// npm install -d grunt-connect-proxy
var proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest;
var mountFolder = function (connect, dir) {
    return connect.static(require('path').resolve(dir));
};
  grunt.initConfig({
        yeoman: yeomanConfig,
        watch: {
              livereload: {
                options: {
                    middleware: function (connect) {
                        return [
                            proxySnippet,   //スニペット追加・・・1
                        ];
                    }
                }
            }
        }
  });

    grunt.registerTask('server', function (target) {
        grunt.task.run([
            'configureProxies',
        ]);

