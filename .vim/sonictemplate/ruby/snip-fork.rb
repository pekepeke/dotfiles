pid = Process.fork {
  {{_cursor_}}
}
Process.waitpid pid
