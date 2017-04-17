## usage

 コマンド          | 説明
-------------------|--------------------------------------------------------------------
 keys *            | redisに登録されているキーの一覧を取得する key のパターンを指定する
 type [key]        | value の種類を返す。
 get [key]         | type が string だった場合の値をみる方法
 lrange [key] 0 -1 | type が list だった場合の値をみる方法
 smembers [key]    | type が set だった場合の値をみる方法
 zrange [key] 0 -1 | type が zsetだった場合の値をみる方法
 hgetall [key]     | type が hash だった場合の値をみる方法
 hkeys [key]       | type が hash だった場合に field の一覧をみる方法
 hvals [key]       | type が hash だった場合に value の一覧をみる方法
 monitor           | redisサーバが受けとったコマンドを表示する

```
redis-cli -h localhost SET hoge bar

> keys *
> type hoge:fuga

```

