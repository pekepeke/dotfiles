samba 関連メモ
==============

## 接続できない系
### Linux

```
# 設定確認
testparm

# 共有サービス一覧確認(古い)
smbclient -L BIGSERVER
smbclient //BIGSERVER/TMP -U vagrant

# nmbd 確認
nmblookup -B BIGSERVER __SAMBA__
nmblookup -B 10.1.255.255 ACLIENT
nmblookup -d 2 '*'
nmblookup -M WORKGROUP

# マウント
mount.cifs //<Windowsのホスト名>/test /home/hoge/test -o user=<Windows共有フォルダのユーザー名>
```

### Windows

```
# nmbd 確認
nbtstat -A 10.1.0.10
nbtstat -a [servername]

# 共有サービス一覧確認
net view 10.1.0.10
net view [servername]

# マウント
net use x: \\BIGSERVER\TMP
# マウント解除
net use x: /delete
```

## Windows で実行権限がつく問題
- http://qiita.com/haoling/items/b306b23c41c7110e9e35

```
[global]
map archive = no
```

## ユーザー管理
- smbpasswd は新しいバージョンだとなくなった

```
pdbedit --list
# add
pdbedit -a user
# delete
pdbedit -x user
```

## 基本的な設定

```
[global]
     unix charset = UTF-8
     dos charset = CP932
     hosts allow = 192.168.
     # hosts allow = 192.168.100.0/24 127.0.0.1/32
     load printers = no
     disable spools = no
     follow symlinks = yes
     wide links = yes
     unix extensions = no
     map archive = no
     max protocol = SMB2 # 速度系のため
     socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=14140000 SO_SNDBUF=14140000 # 必要あれば。パフォーマンス系のパラメータ

```

## public フォルダ

```
   [public]
   comment = Public Stuff
   path = /srv/samba
   guest ok = yes
   public = yes
   writable = yes
   printable = no
```

