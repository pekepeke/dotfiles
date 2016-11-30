Docker
======

## tools
- wait-for-it
	- https://github.com/vishnubob/wait-for-it
- dockerize
	- https://github.com/jwilder/dockerize

## basic

```bash
docker version    # Dockerのバージョン表示
docker info       # コンテナ・イメージ数、ユーザ情報など現在の情報表示

# build image
docker build .
docker build -t REPOSITORY[:TAG] .

## build に失敗した場合のコンテナ確認
docker ps -q --filter status=exited
docker commit -t exited $( docker ps --filter status=exited | peco | awk '{print $1}' )
docker run --rm -it exited sh

# ubuntu_hostというホスト名でubuntuを起動。
docker run -it -h ubuntu_host ubuntu:14.04 /bin/bash 

# 最大メモリ使用量を256MBに制限して起動。終了したらコンテナ自動削除
docker run -it -m 512m --rm ubuntu:14.04 /bin/bash

# redisというコンテナ名でコンテナをバックグラウンドで起動
# (コンテナ名はLink,マウント機能で利用)
docker run -d --name redis dockerfile/redis

# 上で作成したredisコンテナに対してdbというエイリアスをつけてコンテナ間通信
docker run -it --link redis:db ubuntu /bin/bash

# 6379ポートをホストにマッピング、ホストの/data/redisをコンテナの/dataにマッピング
docker run -d -p 6379:6379 -v /data/redis:/data --name redis dockerfile/redis

# コンテナをすべて削除する
docker rm `docker ps -a -q`
# REPOSITORY が <none> のイメージを削除する
docker rmi $(docker images | awk '/^<none>/ { print $3 }')
# 特定の TAG/REPOSITORY イメージを削除
docker rmi local/debian-ja:7.2

# nsenter => exec
## install
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter

## exec
docker ps 
docker inspect --format "{{.State.Pid}}" [id]
sudo nsenter --mount --uts --ipc --net --pid --target $PID

## ビルドを最初からやりなおす
docker build --no-cache .

## 起動中のコンテナ一覧を得る
docker ps

## 停止中のコンテナも含めすべての一覧を得る
docker ps -a

## コンテナのハッシュリストを得る
docker ps -a -q

## 直近で起動したコンテナIDを取得
docker ps -l -q

## ステータスで絞込
docker ps -a -f "exited=127"
docker ps -a -f "exited=137" # sigkill
docker ps -a -f "status=running" # created/restarting/running/paused/exited
docker ps -a -f "status=exited"

## index.docker.ioからイメージを検索する
docker search TERM

## イメージをビルドした際のコマンドリストを得る。Dockerfileに記述したもののみ
docker history IMAGE

## イメージをファイル出力する
docker save IMAGE > filename.tar

## ファイルをイメージとして取り込む
docker load < filename.tar

## コンテナからイメージ作成
docker commit CONTAINER REPOSITORY[:TAG]

## コンテナをファイル出力
docker export CONTAINER > filename.tar

## ファイルからイメージ取込
cat filename.tar | docker import - REPOSITORY[:TAG]

## URLからイメージ取込
docker import url REPOSITORY[:TAG]

## コンテナ内のファイルをホストにコピーする
docker cp CONTAINER:filename ./

## URLのファイルをイメージ内のPATHに生成する
docker insert IMAGE URL PATH

## コンテナの実行中のプロセス一覧を見る
docker top CONTAINER

## コンテナ内のイベントを監視する（コンテナが作られた、起動した、停止したなど)
docker events

## コンテナ内でコマンドを実行する
docker exec CONTAINER コマンド

## コンテナ内でコマンドを対話式に実行する
docker exec -it CONTAINER コマンド
```


## change detach key 
- `~/.docker/config.json`

```
{
    "auths": {
        "https://hoge.docker.io/v1/": {
            "auth": "****",
            "email": "****"
        }
    },
    "detachKey": "ctrl-a,a"
}
```

## tips

### call remote api
- remote api - `https://docs.docker.com/engine/reference/api/docker_remote_api/`

```
# socat version
echo -e "GET /images/json HTTP/1.1\r\n" | socat unix-connect:/var/run/docker.sock STDIO

# nc version (netcat-freebsd)
echo -e "GET /images/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock
echo -e "GET /images/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock | sed 1,4d

# curl version
curl --unix-socket /var/run/docker.sock http:/containers/json

# relay
socat -d -d TCP-LISTEN:8080,fork UNIX:/var/run/docker.sock
ncat -vlk 8080 -c 'ncat -U /var/run/docker.sock

curl http://localhost:8080

# php socket
php -r '$fs = fsockopen("unix:///var/run/docker.sock"); fwrite($fs, "GET /containers/json HTTP/1.1\r\nHOST: http:/\r\n\r\n"); while (!feof($fs)) { print fread($fs, 4096); }'
```

### 参照していない data-volume のクリア

```
docker volume ls -qf dangling=true

docker volume rm $(docker volume ls -qf dangling=true)
docker volume ls -qf dangling=true | xargs -r docker volume rm

# https://github.com/chadoe/docker-cleanup-volumes
curl -LO https://raw.githubusercontent.com/chadoe/docker-cleanup-volumes/master/docker-cleanup-volumes.sh
for id in $( sudo ./docker-cleanup-volumes.sh --dry-run | grep "deleted" | awk '{print $NF}') ; do sudo ls -al /var/lib/docker/volumes/$id/_data ; done
for id in $( sudo ./docker-cleanup-volumes.sh --dry-run | grep "In use" | awk '{print $NF}') ; do sudo ls -al /var/lib/docker/volumes/$id/_data ; done
```

### build
#### build-time arguments
- https://docs.docker.com/engine/reference/builder/#arg
	- Dockerfile内でARG命令で定義した変数の値を--build-argオプションで指定できる
	- 初期では、HTTP_PROXYやno_proxyなど8つの変数が定義済み
	- ARG命令で変数を定義するときデフォルト値を設定することも可能
	- 未定義の変数を--build-argオプションで指定するとエラー
	- Dockerfile内においてARG命令は定義された行から有効になる、それ以前の行では未定義
	- ENV命令で定義された変数はARG命令とは異なりビルドイメージでも有効

```
docker build --build-arg HTTP_PROXY=http://proxy.example.com:8080 .

mkdir -p /tmp/cache
http-replicator -r /tmp/cache -p 8888 --daemon /tmp/replicator.log
docker build --build-arg http_proxy=http://172.17.0.1:8888 .
docker build --build-arg http_proxy=http://172.17.0.1:8888 .
```

### pid -> container 確認

```
/proc/$PID/cgroup
docker ps -q | xargs -n1 docker top
```

