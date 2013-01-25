pid = Process.fork {
  {{_cursor_}}
}
begin
  status = Timeout::timeout(5) {
    Process.waitpid2(pid)
  }
rescue Timeout::Error
  Process.kill('KILL', pid)
end
