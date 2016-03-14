## basic

```bash
docker version    # Dockerのバージョン表示
docker info       # コンテナ・イメージ数、ユーザ情報など現在の情報表示

# build image
docker build .
docker build -t REPOSITORY[:TAG] .

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
docker build --build-arg HTTP_PROXY=http://172.17.0.1:8888 .
```


