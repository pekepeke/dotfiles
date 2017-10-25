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
# sshd_config に GatewayPorts clientspecified の設定が必要(yes でも可能)
ssh -R -f -N 0.0.0.0:80:example.com:9999 username@example.com
```
- `-R` : リモートフォワードを有効 80:example.com:9999 でexample.com:9876->localhost:80転送
- `-f` : バックグランドで実行
- `-N` : コマンド実行をしない(ログインだけしてシェルも立ち上げない)

```
Host example.com
  RemoteForward 9999 localhost:80
# うまく動作しない場合 sshd_config の GatewayPorts を確認する
```

## socks proxy(dynamic port forward)

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
ssh-keygen -t rsa -b 4096
# ssh-keygen -t rsa -b 4096 -C "email@example.com"
# ssh-keygen -t rsa -b 4096

# 公開鍵コピー
ssh-copy-id -i .ssh/id_dsa.pub user@192.168.1.16

# PEMパスフレーズ解除
openssl rsa -in ssl.pem -out ssl-nopass.pem
chmod 600 ssl-nopass.pem

# remove fingerprint
ssh-keygen -R remote_host_name

# confirm fingerprint
ssh-keygen -lf ~/.ssh/id_rsa.pub
```

### ssh 鍵の強度確認

```
# 2048 以上+ RSA(or ECDSA, ED25519)
ssh-keygen -l -f ~/.ssh/id_rsa.pub
```
## completion

```
_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config | grep -v '[?*]' | cut -d ' ' -f 2-)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh
```

### sshd error: could not load host key

#### debian

```
sudo rm -r /etc/ssh/ssh*key
sudo dpkg-reconfigure openssh-server
```

#### centos

```
sudo rm -r /etc/ssh/ssh*key
sudo systemctl restart sshd
```

#### manual

```
sudo ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -P ""
sudo ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -P ""
sudo ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -P ""
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

