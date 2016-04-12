SSH
===

## port forwarding

```
ssh -L 8080:remote:80 user@example.com
```

- ローカル

## reverse port fowarding

```
ssh -R -f -N 80:example.com:9999 username@example.com
```
- `-R` : リモートフォワードを有効 80:example.com:9999 でexample.com:9876->localhost:80転送
- `-f` : バックグランドで実行
- `-N` : コマンド実行をしない(ログインだけしてシェルも立ち上げない)

```
Host example.com
  RemoteForward 9999 localhost:80
# うまく動作しない場合 sshd_config の GatewayPorts を確認する
```

## socks proxy(dynamic port foward)

```
ssh -f -N -D 1080 user@example.com
ssh -N -D 1080 user@example.com

# 名前解決は自前
proxy=socks5://127.0.0.1:8080
HTTP_PROXY=$proxy HTTPS_PROXY=$proxy http_proxy=$proxy https_proxy=$proxy wget http://hoge
ALL_PROXY=$proxy wget http://hoge
curl --socks5 :8080
curl --socks5 localhost:8080
curl --socks5-hostname localhost:8080
# 名前解決を proxy 側で実施
proxy=socks5h://127.0.0.1:8080
HTTP_PROXY=$proxy HTTPS_PROXY=$proxy http_proxy=$proxy https_proxy=$proxy wget http://hoge

# git
proxy=socks5://127.0.0.1:1080
git clone https://hoge/piyo.git --config "http.proxy=$proxy"
git config --global http.proxy $proxy
git config --global https.proxy $proxy

git config --global --unset http.proxy
git config --global --unset https.proxy
```

## create key

```
# 鍵の登録
ssh-keygen -t rsa
ssh-copy-id -i .ssh/id_dsa.pub user@192.168.1.16

# PEMパスフレーズ解除
openssl rsa -in ssl.pem -out ssl-nopass.pem
chmod 600 ssl-nopass.pem

# remove fingerprint
ssh-keygen -R remote_host_name

# confirm fingerprint
ssh-keygen -lf ~/.ssh/id_rsa.pub
```

## sshfuse
### install

```
sudo apt-get install sshfs
```

### usage

```
sshfs [host]:[dir] [mount]
fusermount -u [mount]
```

