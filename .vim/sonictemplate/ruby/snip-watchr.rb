script = Watchr::Script.new
script.watch(File.join("{{_cursor_}}", ".*\.(php|js|css|png|gif|jpg)$")) {|md|
}
controller = Watchr::Controller.new(script, Watchr.handler.new)
controller.run

