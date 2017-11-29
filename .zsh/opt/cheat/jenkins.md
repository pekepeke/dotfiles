
### 環境変数

| 環境変数        | 説明 |
|:---------------:|:----:|
| BUILD_NUMBER    | "153"のような現在のビルド番号。|
| BUILD_ID        | "2005-08-22_23-59-59" ( YYYY-MM-DD_hh-mm-ss 形式)のような現在のビルドのID。|
| JOB_NAME        | このビルドのプロジェクト名。この名前は最初に設定を行った際に設定したジョブ名です。Jenkinsのメイン画面であるダッシュボードの3番目のカラムの値です。|
| BUILD_TAG       | jenkins-${JOBNAME}-${BUILD_NUMBER} 形式の文字列。リソースファイル、jarファイルなどを容易に識別するために便利です。|
| EXECUTOR_NUMBER | このビルドを実行するエグゼキューターを識別（同一マシン内で）するユニークな番号。"ビルド実行状態"で表示されている番号ですが、1ではなく0始まりです。|
| JAVA_HOME       | ジョブが特定のJDKを使用する場合、設定されていればそのJDKの JAVA_HOME 。パスも $JAVA_HOME/bin にアップデートされます。.|
| WORKSPACE       | ワークスペースの絶対パス。|
| SVN_REVISION    | Subversionを使用したプロジェクトにおけるそのモジュールのリビジョン番号。|
| CVS_BRANCH      | CVSを使用したプロジェクトにおけるそのモジュールのブランチ。トランクをチェックアウトする場合設定されません。|


JENKINS_URL, JOB_URL, BUILD_URL

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


