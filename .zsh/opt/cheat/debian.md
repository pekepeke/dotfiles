debian memo
===========

### サービス管理

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


### locale
- aptでlanguage-packを追加する

```
apt-get install language-pack-ja
```

- locale-genする

```
locale-gen ja_JP.UTF-8
update-locale LANG=ja_JP.UTF-8
```

### timezone

```
cp -p /etc/localtime /etc/localtime.org
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```

### apt-get
- `apt-get install [package]`
	- パッケージのインストール/更新
- `apt-get update`
	- パッケージリストの更新
- `apt-get upgrade`
	- インストールされてるパッケージの更新
- `apt-get dist-upgrade`
	- インストールされてるカーネルの更新(Ubuntu)/ディストリビューションの更新(Debian)
- `dpkg -l [package]`
	- インストールされてるパッケージの一覧
- `dpkg -L`
	- インストールした時のファイルの一覧
- `apt-cache search [query]`
	- パッケージの検索
- `apt-cache policy [query]`
	- パッケージの検索 (インストール可能なバージョンの表示）
- `apt-cache madison [query]`
	- パッケージの検索 (インストール可能なバージョンの一覧）
- `apt-get remove [package]`
	- パッケージの削除
- `apt-get autoremove`
	- 使ってないパッケージの削除
- `apt-get purge [package]`
	- パッケージの削除（設定ファイルも）
- `apt-get clean`
	- アーカイブファイルの削除
- `apt-get autoclean`
	- 使ってないパッケージのアーカイブファイルの削除

