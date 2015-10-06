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

# nsenter
## install
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter

## exec
docker ps 
docker inspect --format "{{.State.Pid}}" [id]
sudo nsenter --mount --uts --ipc --net --pid --target $PID

```
