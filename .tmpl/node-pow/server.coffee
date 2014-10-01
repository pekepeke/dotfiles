connect = require("connect")
http = require("http")
serveStatic = require('serve-static')
config = require("./package.json")
root = __dirname

console.log "root: %s", root
app = connect()
  .use(serveStatic(root))
http.createServer(app).listen config.port
