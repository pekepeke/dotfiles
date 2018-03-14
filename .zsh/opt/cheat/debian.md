debian memo
===========

## ubuntu
### visudo のエディタ変更

```
sudo update-alternatives --set editor
sudo update-alternatives --set editor /usr/bin/vim.basic
```
- http://graziegrazie.hatenablog.com/entry/2015/11/14/101050

### パッケージ検索
- https://packages.ubuntu.com/

### swap 追加

```
dd if=/dev/zero of=/swap.extended bs=1M count=2048
mkswap /swap.extended
swapon /swap.extended
```

- /etc/fstab に記載
```
/swap.extended          swap                    swap    defaults        0 0
```

### apt-file

```
sudo apt install apt-file
# どのパッケージに含まれているかを調査できるやつ
apt-file update
apt-file search apt-add-repository
```

### golang 1.8

```
# add-apt-repository がない場合
sudo apt-get install software-properties-common python-software-properties  apt-transport-https ca-certificates curl
# install golang 1.8
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt-get update
sudo apt-get install golang-go
```

## visudo editor

```
sudo update-alternatives --config editor
```

## サービス管理

```
update-rc.d <service> defaults
update-rc.d <service> start 20 3 4 5
update-rc.d <service> disable
update-rc.d -f <service>  remove
```

```
sudo apt-get install sysv-rc-conf
sysv-rc-conf --list
sysv-rc-conf apache2 on
sysv-rc-conf apache2 off
sysv-rc-conf --list apache2
```

### wheel group

```
addgroup --gid 11 wheel
visudo
# %wheel  ALL=(ALL) ALL
gpasswd -a hoge wheel

```

### サービスメモ
- avahi-daemon
	- Apple方式の自動デバイス検出機能
- apparmor
	- アプリ単位で行動ルールを制限するための仕組み

## locale
- aptでlanguage-packを追加する

```
apt-get install language-pack-ja
```

- locale-genする

```
locale-gen ja_JP.UTF-8
update-locale LANG=ja_JP.UTF-8
```

## timezone

```
cp -p /etc/localtime /etc/localtime.org
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

## apt-get
- パッケージのインストール/更新
	- `apt-get install [package]`
	- `aptitude install [package]`
	- `apt-get install --no-install-recommends`
- パッケージリストの更新
	- `apt-get update`
	- `aptitude update`
- インストールされてるパッケージの更新
	- `apt-get upgrade`
	- `aptitude safe-upgrade`
- インストールされてるカーネルの更新(Ubuntu)/ディストリビューションの更新(Debian)
	- `apt-get dist-upgrade`
	- `aptitude full-upgrade`
- 依存パッケージのインストール
	- `apt-get build-dep [package]`
- パッケージの削除(設定ファイルは残したまま)
	- `apt-get remove [package]`
	- `aptitude remove [package]`
- 使ってないパッケージの削除
	- `apt-get autoremove`
- パッケージの削除（設定ファイルも）
	- `apt-get purge [package]`
	- `apt-get --purge remove [package]`
- アーカイブファイルの削除
	- `apt-get clean`
	- `aptitude clean`
- 使ってないパッケージのアーカイブファイルの削除
	- `apt-get autoclean`

- パッケージの検索
	- `apt-cache search [query]`
- パッケージの検索 (インストール可能なバージョンの表示）
	- `apt-cache policy [query]`
- パッケージの検索 (インストール可能なバージョンの一覧）
	- `apt-cache madison [query]`
- パッケージ情報表示
	- `apt-cache show [package]`
	- `aptitude show [package]`

- `dpkg -l [package]`
	- インストールされてるパッケージの一覧
- `dpkg -L`
	- インストールした時のファイルの一覧

### GPGエラー対処

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys [NO_PUBKEY]
sudo apt-get update
```

## apparmor

### profile の作成
```
sudo apt-get install apparmor-profiles apparmor-utils
sudo apparmor_status
# profile 作成
sudo aa-genprof /usr/bin/polipo
# 学習モード
sudo aa-complain /usr/bin/polipo
# 学習開始
sudo service polipo restart
# 学習結果の反映
sudo aa-logprof
# enforce モードにきりかえ
sudo aa-enforce polipo
```

## ufw

```
# 設定確認
sudo ufw status

# port
sudo ufw allow 80/tcp
sudo ufw allow 80/tcp

# ip range
sudo ufw allow from 192.168.254.0/24
# ip + port
sudo ufw allow from 192.168.254.20 to any port ssh

sudo ufw allow from 192.168.254.10 to any port ssh
# ssh に制限をいれる
sudo ufw limit ssh
# limit にかかっている状態だと設定追加できないのでdelete してから実行する
sudo ufw delete limit ssh
sudo ufw allow from 192.168.254.10 to any port ssh
sudo ufw limit ssh

sudo ufw status numbered
# 特定の位置にルールを追加
sudo ufw insert 1 limit from 192.168.254.20 to any port ssh

sudo ufw allow in on docker0

sudo ufw reload

# 有効化, 無効化
sudo ufw disable
sudo ufw enable

# デフォの通信設定
sudo ufw default allow
sudo ufw default deny
```

## iptabls の永続化

```
apt install iptables-persistent

# /etc/iptables/rules.v4 , /etc/iptables/rules.v6 に保存
/etc/init.d/iptables-persistent save
/etc/init.d/iptables-persistent reload
# /etc/init.d/netfilter-persistent
```
