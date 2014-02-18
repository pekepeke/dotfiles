child = require('child_process').exec(cmd)
child.stdout.on "data", (d) -> console.log d
child.stderr.on "data", (d) -> console.error d
child.on "exit", (code) ->
  if code > 0
    console.error "Exited with code %d.", code
    return
  console.log "Exited with code: %d", code

