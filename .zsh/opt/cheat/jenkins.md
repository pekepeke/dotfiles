

### Scripting

```
void system(String command){
  def out = new StringBuilder()
  def err = new StringBuilder()
  
  println "> $command"
  def proc = command.execute()
  proc.waitForProcessOutput(out, err)
  if (out) println "out:\n$out"
  if (err) println "err:\n$err"
}

system "whoami"

```
