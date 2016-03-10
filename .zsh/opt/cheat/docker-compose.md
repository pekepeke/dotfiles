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

### 環境変数参照
```
docker-compose run [service] env
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

#### image
- タグや image ID の一部を指定する

```
image: ubuntu
image: orchardup/postgresql
image: a4bc65fd
```

#### build
- Dockerfile のあるディレクトリのパスを指定します。

```
build: /path/to/build/dir
```

#### dockerfile
- Compose は構築時に指定されたファイルを使います。

```
dockerfile: Dockerfile-alternate
```

#### command
- デフォルトのコマンドを上書きします。

```
command: bundle exec thin -p 3000
```

#### links
- コンテナを他のサービスにリンクします。

```
links:
 - db
 - db:database
 - redis
```

#### external_links
- `docker-compose.yml` や、とりわけ Compose の外にある共有ないし共通サービスが提供するコンテナとリンクします。

```
external_links:
 - redis_1
 - project_db_1:mysql
 - project_db_1:postgresql
```

#### extra_hosts
- ホスト名のマッピングを追加します。docker クライアントの `--add-host` パラメータと同じ値です。

```
extra_hosts:
 - "somehost:162.242.195.82"
 - "otherhost:50.31.209.229"
```

#### ports
- ポートを公開（expose）します。ホストとポートを指定（`ホスト:コンテナ`）するか、コンテナのポートのみ指定します（ホスト側のポートはランダムに選ばれます）。


```
ports:
 - "3000"
 - "8000:8000"
 - "49100:22"
 - "127.0.0.1:8001:8001"
```

#### expose
- ホストマシン上にポートを露出（expose）させる。

```
expose:
 - "3000"
 - "8000"
```

#### volumes

- パスをボリュームとしてマウントします。

```
volumes:
 - /var/lib/mysql
 - cache/:/tmp/cache
 - ~/configs:/etc/configs/:ro
```

#### volumes_from
- 他のサービスやコンテナから、全てのボリュームをマウントします。

```
volumes_from:
 - service_name
 - container_name
```

#### environment
- 環境変数を追加します。配列や dictionary での指定が可能

```
environment:
  RACK_ENV: development
  SESSION_SECRET:

environment:
  - RACK_ENV=development
  - SESSION_SECRET
```

#### env_file
- ファイルから環境変数を追加します。リストには１つの値です。
	- `environment` で指定した環境変数は、これらの値に上書きされます。

```
env_file: .env

env_file:
  - ./common.env
  - ./apps/web.env
  - /opt/secrets.env
```

```
# 環境変数 Rails/Rack の設定
RACK_ENV=development
```

#### extends
- 現在のファイルや別のファイルから、他のサービスを拡張します。オプションで設定を上書きします。


```common.yml
webapp:
  build: ./webapp
  environment:
    - DEBUG=false
    - SEND_EMAILS=false
```

```development.yml
web:
  extends:
    file: common.yml
    service: webapp
  ports:
    - "8000:8000"
  links:
    - db
  environment:
    - DEBUG=true
db:
  image: postgres
```

#### lables
- http://docs.docker.com/userguide/labels-custom-metadata/

```
labels:
  com.example.description: "Accounting webapp"
  com.example.department: "Finance"
  com.example.label-with-empty-value: ""

labels:
  - "com.example.description=Accounting webapp"
  - "com.example.department=Finance"
  - "com.example.label-with-empty-value"
```

#### log driver
- ログ記録用のドライバを指定します。
- デフォルトの値は `json-file`

```
log_driver: "json-file"
log_driver: "syslog"
log_driver: "none"
```

#### net
- ネットワーキング・モードを指定します。

```
net: "bridge"
net: "none"
net: "container:[name or id]"
net: "host"
```

#### pid
- PID モードを host PID モードにセットする。コンテナとホスト・オペレーティング・システム上の PID アドレス空間を共有する。
	- 他のコンテナにアクセス・操作できるように、コンテナ起動時にこのフラグを使う。

```
pid: "host"
```


#### dns
- DNS サーバーを設定します。

```
dns: 8.8.8.8
dns:
  - 8.8.8.8
  - 9.9.9.9
```

#### cap_add, cap_drop
- コンテナの性能を追加したり下げたり。`man 7 capabilities`

```
cap_add:
  - ALL

cap_drop:
  - NET_ADMIN
  - SYS_ADMIN
```

#### dns_search
- DNS の search ドメインを設定します。１つまたはリストで記述します。

```
dns_search: example.com
dns_search:
  - 8.8.8.8
  - dns.example.com
```

#### devices
- デバイス・マッピングの一覧

```
devices:
  - "/dev/ttyUSB0:/dev/ttyUSB0"
```

#### security_opt
- デフォルトのラベリング・スキーマを上書きします。

```
  security_opt:
    - label:user:USER
    - label:role:ROLE
```

#### working_dir, entrypoint, user, hostname, domainname, mem_limit, privileged, restart, stdin_open, tty, cpu_shares, cpuset, read_only
- https://docs.docker.com/reference/run/ 参照

```
cpu_shares: 73
cpuset: 0,1

working_dir: /code
entrypoint: /code/entrypoint.sh
user: postgresql

hostname: foo
domainname: foo.com

mem_limit: 1000000000
privileged: true

restart: always

stdin_open: true
tty: true
read_only: true
```


