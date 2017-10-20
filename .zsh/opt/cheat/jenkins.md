

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

### cli
- $JENKINS_HOME/war/WEB-INF/jenkins-cli.jar
	- war/WEB-INF/jenkins-cli.jar
```
java -jar jenkins-cli.jar --username [user] --password [pass]
java -jar jenkins-cli.jar -noCertificateCheck -s [JENKINS_URL] build [JOB]
java -jar jenkins-cli.jar -s http://localhost:8080 copy-job [src] [dst]
java -jar jenkins-cli.jar -s http://localhost:8080 delete-builds myproject '1-7499'
```


