telnet
======

## send mail

```
telnet localhost 25
HELO localhost
MAIL FROM:from@localhost
RCPT TO:from@localhost
DATA
Subject:
From:from@localhost
To:to@localhost
test mail
.
QUIT
```

## memcached

```
telnet localhost 11211
# set key, flag(0:非圧縮,1:圧縮), expires(秒数), byte
set foo 0 100 3
# get key
get foo
# データの先頭へ追加
pretend foo 1
# データの末尾へ追加
append foo 2
# データ削除
delete test
# 全データ削除
flush all
# key一覧 items:[int2]:number [int2] のものを探す -> stats cachedump [int1] [int2]
stats items
stats cachedump 4 6
```
