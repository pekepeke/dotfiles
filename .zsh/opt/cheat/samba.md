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
     # セキュリティ周り
     security = user
     passdb backend = tdbsam

     # guest 設定(設定なしでOK)
     guest account = nobody
     map to guest = Bad User
     # 文字コード
     unix charset = UTF-8
     dos charset = CP932
     # 接続インタフェースの制限
     interfaces =  127.0.0.0/8 eth0
     bind interfaces only = yes
     # 許可IP設定
     hosts allow = 10.0.0.0/8 172.16.0.0/12 192.168.100.0/24 127.0.0.1/32
     # プリンタ関連 - https://inataya.wordpress.com/2015/11/10/samba-のプリンタ共有を正しく無効化する/
     # 有効化する場合は http://web.mit.edu/rhel-doc/4/RH-DOCS/rhel-rg-ja-4/s1-samba-cups.html
     load printers = no
     printing = bsd
     printcap name = /dev/null
     # disable spools = no
     follow symlinks = yes
     wide links = yes
     unix extensions = no
     map archive = no
     # 速度系のため
     max protocol = SMB2
     # 必要あれば。パフォーマンス系のパラメータ
     # socket options = TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=14140000 SO_SNDBUF=14140000

```

## public フォルダ

```
   [public]
   comment = Public Stuff
   path = /srv/samba
   # guestアクセスを許可する場合は、共有フォルダのパーミッションを666に変更しておく。
   guest ok = yes
   public = yes
   writable = yes
   printable = no

```

## user フォルダ

```
[homes]
    comment = Home Directories
    # writable = yes
    # valid users = %S
    # valid users = MYDOMAIN\%S

    path = %H/samba
    browseable = no
    # writable = yes
    create mask = 0755
    # directory mask = 0755
    # users = %S
```

