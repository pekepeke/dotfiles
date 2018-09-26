
### 設定一括変更

#### シェルスクリプトで
設定の再読込が必要.

```
find ./*/config.xml | xargs grep "notifySuccess"
find ./*/config.xml | xargs -i cp -p {} {}.$(date +'%Y%m%d')
find ./*/config.xml | xargs sed -i -e "s%<notifySuccess>true</notifySuccess>%<notifySuccess>false</notifySuccess>%g"
```

#### スクリプトコンソールで編集

```
jenkins.model.Jenkins.instance.items.each {
  println "Job : ${it.name}"
  def mailer = it.publisherList.get(hudson.tasks.Mailer.class)
  mailer?.recipients += ' foo@example.com'
}
```

#### Configuration Slicing Plugin
標準的な項目をGUI上で一括編集できる


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

### CSP

```
System.setProperty("hudson.model.DirectoryBrowserSupport.CSP", "sandbox allow-scripts allow-same-origin; default-src 'self' * data:; img-src 'self' data: *; style-src 'self' 'unsafe-inline' *; font-src 'self' data: *; child-src 'self' *; frame-src 'self' *; script-src 'self' 'unsafe-inline' 'unsafe-eval' *; frame-ancestors 'self' *;")
```

### Scripting

```
void system(String command){
  def out = new StringBuilder()
  def err = new StringBuilder()
  
  println "> $command"
  def proc = commandcute()
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

# ジョブ一覧
java -jar jenkins-cli.jar -s http://localhost:8080 list-jobs
# ジョブの無効化
java -jar jenkins-cli.jar -s http://localhost:8080 disable-job "ジョブ名"
# ジョブの有効化
java -jar jenkins-cli.jar -s http://localhost:8080 enable-job "ジョブ名"

```

| JenkinsCLIで利用可能なコマンド |                                                                                                                  |
|--------------------------------|------------------------------------------------------------------------------------------------------------------|
| build                          | ジョブをビルドします。オプションで完了するまで待ちます。                                                         |
| cancel-quiet-down              | quite-downコマンドの処理をキャンセルします。                                                                     |
| clear-queue                    | ビルドキューをクリアします。                                                                                     |
| connect-node                   | ノードと再接続します。                                                                                           |
| console                        | ビルドのコンソール出力を取得します。                                                                             |
| copy-job                       | ジョブをコピーします。                                                                                           |
| create-job                     | 標準入力をConfig XMLとして読み込み、ジョブを新規に作成します。                                                   |
| create-node                    | 標準入力をConfig XMLとして読み込み、ノードを新規に作成します。                                                   |
| create-view                    | Creates a new view by reading stdin as a XML configuration.                                                      |
| delete-builds                  | ビルドを削除します。                                                                                             |
| delete-job                     | ジョブを削除します。                                                                                             |
| delete-node                    | ノードを削除します。                                                                                             |
| delete-view                    | Deletes view.                                                                                                    |
| disable-job                    | ジョブを無効化します。                                                                                           |
| disconnect-node                | ノードとの接続を切断します。                                                                                     |
| enable-job                     | ジョブを有効化します。                                                                                           |
| get-job                        | ジョブ定義XMLを標準出力に出力します。                                                                            |
| get-node                       | ノード定義XMLを標準出力に出力します。                                                                            |
| get-view                       | Dumps the view definition XML to stdout.                                                                         |
| groovy                         | 指定したGroovyスクリプトを実行します。                                                                           |
| groovysh                       | 対話式のGroovyシェルを起動します。                                                                               |
| help                           | 利用可能なコマンドの一覧を表示します。                                                                           |
| install-plugin                 | ファイル、URLおよびアップデートセンターからプラグインをインストールします。                                      |
| install-tool                   | ツールの自動インストールを実行し、インストール先を表示します。                                                   |
| keep-build                     | ビルドを保存するようにマークします。                                                                             |
| list-changes                   | 指定したビルドの変更履歴を表示します。                                                                           |
| list-jobs                      | 指定したビューかItem Groupのすべてのジョブを一覧表示します。                                                     |
| list-plugins                   | インストール済みのプラグインを一覧表示します。                                                                   |
| login                          | 認証情報を保存して、認証情報なしにコマンドを実行できるようにします。                                             |
| logout                         | loginコマンドで保存した認証情報を削除します。                                                                    |
| mail                           | 標準入力の内容をメールとして送信します。                                                                         |
| offline-node                   | online-nodeコマンドが実行されるまで、ビルドを実行するノードの使用を一時的に停止します。                          |
| online-node                    | 直前に実行した"online-node"コマンドを取り消し、ビルドを実行するノードの使用を再開します。                        |
| quiet-down                     | Jenkinsは再起動に向けて終了処理を実施中です。ビルドを開始しないでください。                                      |
| reload-configuration           | メモリにあるすべてのデータを破棄して、ファイルから再ロードします。設定ファイルを直接修正した場合に役に立ちます。 |
| reload-job                     | Reloads this job from disk.                                                                                      |
| restart                        | Jenkinsを再起動します。                                                                                          |
| safe-restart                   | Jenkinsを安全に再起動します。                                                                                    |
| safe-shutdown                  | Jenkinsを終了モードに変更しビルドが完了後に、シャットダウンします。                                              |
| session-id                     | Jenkinsの再起動ごとに変化するセッションIDを出力します。                                                          |
| set-build-description          | ビルドの説明を設定します。                                                                                       |
| set-build-display-name         | ビルドの名称を設定します。                                                                                       |
| set-build-parameter            | 現在実行中のビルドのビルドパラメータを設定、更新します。                                                         |
| set-build-result               | 現在のビルドの結果を設定します。ビルド中に呼び出された場合のみ動作します。                                       |
| set-external-build-result      | Set external monitor job result.                                                                                 |
| shutdown                       | Jenkinsサーバーを直ちにシャットダウンします。                                                                    |
| update-job                     | 標準入力からの情報でジョブ定義XMLを更新します。get-jobコマンドの正反対のことを行います。                         |
| update-node                    | 標準入力からの情報でノード定義XMLを更新します。get-nodeコマンドの正反対のことを行います。                        |
| update-view                    | Updates the view definition XML from stdin. The opposite of the get-view command.                                |
| version                        | バージョンを表示します。                                                                                         |
| wait-node-offline              | ノードがオフラインになるのを待ちます。                                                                           |
| wait-node-online               | ノードがオンラインになるのを待ちます。                                                                           |
| who-am-i                       | 認証情報を表示します。                                                                                           |

