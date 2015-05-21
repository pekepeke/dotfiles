## 設定
### COMPOSE_PROJECT_NAME
- プロジェクト名の設定。デフォルトでは YAML ファイルのあるディレクトリの basename になる。
	- `export COMPOSE_PROJECT_NAME=hello_world`

### COMPOSE_FILE
- YAML ファイルのパス。デフォルトはカレントディレクトリの docker-compose.yml
	- `export COMPOSE_FILE=docker-compose.production.yml`

### DOCKER_HOST
- docker CLI と同じく docker デーモンの URL を指定できる。デフォルトは unix:///var/run/docker.sock
	- `export DOCKER_HOST=tcp://172.17.8.101:2375`

## コマンド
### コンテナのビルド
```
docker-compose build
```

### コマンドの実行
```
docker-compose run web path/to/command args
```

### 起動
```
docker-compose up
# background
docker-compose up -d
# container の停止/再構築をおこなわない、停止状態の container の起動から
docker-compose up --no-recreate
```

### 状態
```
docker-compose ps
```

### ログ
```
docker-compose logs
```

### start/stop/restart
```
# コンテナをサービスとして開始/停止/再起動する
docker-compose start
docker-compose stop
docker-compose restart
```

## docker-compose.yml
Option名       |意味                                                                                        
---------------|--------------------------------------------------------------------------------------------
links          |別のContainerを参照する場合に使う、docker run --linkに相当                                  
external_links |docker-compose.ymlに書かれて無い別containerを参照する場合に使う, docker-compose v1.1の新機能
ports          |Host側にPortをbindする場合に使う、docker run -pに相当、exposeとの使い分けに注意             
expose         |Host側にPortをbindせずに別containerと通信する場合に使う、portsとの使い分けに注意            
volumes        |host linuxのdirectoryをcontainer側にmountする場合に使う、docker run -vに相当                
command        |DockerfileのCMDを上書きしてする場合に使う                                                   
environment    |container内での環境変数を追加設定する                                                       

