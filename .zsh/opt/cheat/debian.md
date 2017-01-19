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
- パッケージのインストール/更新
	- `apt-get install [package]`
	- `aptitude install [package]`
- パッケージリストの更新
	- `apt-get update`
	- `aptitude update`
- インストールされてるパッケージの更新
	- `apt-get upgrade`
	- `aptitude safe-upgrade`
- インストールされてるカーネルの更新(Ubuntu)/ディストリビューションの更新(Debian)
	- `apt-get dist-upgrade`
	- `aptitude full-upgrade`
- パッケージの削除(設定ファイルは残したまま)
	- `apt-get remove [package]`
	- `aptitude remove [package]`
- 使ってないパッケージの削除
	- `apt-get autoremove`
- パッケージの削除（設定ファイルも）
	- `apt-get purge [package]`
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
