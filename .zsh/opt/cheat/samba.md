samba 関連メモ
==============

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

