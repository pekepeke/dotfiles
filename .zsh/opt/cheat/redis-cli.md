## option

| オプション                | 説明                                                                       | 備考                                                                                                                           |
|---------------------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| -h <hostname>             | ホスト名を指定                                                             | デフォルトは127.0.0.1                                                                                                          |
| -p <port>                 | ポート番号を指定                                                           | デフォルトは6379                                                                                                               |
| -s <socket>               | サーバのソケットを指定                                                     | これが設定されると-hと-pの設定を無視します                                                                                     |
| -a <password>             | パスワードを指定                                                           | requireが設定されている時、毎回「AUTHコマンド」を実行する必要がなくなります                                                    |
| -r <repeat>               | 繰り返し実行                                                               | 指定したコマンドを<repeat>回繰り返します                                                                                       |
| -i <interval>             | 繰り返し間隔                                                               | -rオプションが指定されている時、<interval>秒の間隔で実行します                                                                 |
| -n <db>                   | データベースの番号                                                         | SELECTコマンドで指定するやつです                                                                                               |
| -x                        | 最後の引数を標準入力から読み込む                                           | 「SETコマンドのVAUEの部分だけを標準入力から指定する」みたいなことが可能                                                        |
| -d                        | --rawを指定した時の、区切り文字を指定                                      | '\r\n'に代わる区切り文字を指定する                                                                                             |
| -c                        | クラスタモードで接続                                                       | -ASKや-MOVEDのリダイレクトを許可します                                                                                         |
| --raw                     | マルチバイト対応を許可                                                     | --rawを指定するとマルチバイト文字がちゃんと返ってきます                                                                        |
| --no-raw                  | マルチバイト対応を許可しない                                               | -                                                                                                                              |
| --csv                     | 出力をCSV形式にする                                                        | -                                                                                                                              |
| --stat                    | redis serverの稼働情報を表示し続ける                                       | 総キー数、総メモリ数、クライアント数などを表示し続ける。稼働監視用オプション                                                   |
| --latency                 | レイテンシ計測モードを使用                                                 | レイテンシを計測できる(Ctl-Cで止めるまで計測し続ける)                                                                          |
| --latency-history         | レイテンシ計測結果を15秒間隔で表示                                         | --latencyと似ているが、15秒ごとにレイテンシの経過を見れる点が異なる(Ctl-Cで止めるまで計測し続ける)                             |
| --slave                   | マスタサーバから来たコマンドを表示し続ける                                 | スレーブサーバにはマスタサーバからどんなコマンドが来ているだろう？レプリケーションはちゃんと動いている？というときに使えます。 |
| --rdb <filename>          | RDBファイルを取得                                                          | 接続サーバのRDBファイルを取得。リモートサーバに対してのダンプコマンドと思っていいかも？                                        |
| --pipe                    | pipeモードを使用                                                           | 大量にデータを登録する時とかに便利です                                                                                         |
| --pipe-timeout <n>        | pipeモードのタイムアウトを指定                                             | 単位は秒                                                                                                                       |
| --bigkeys                 | 格納しているデータの中で一番サイズの大きいVALUEを持つKEYをデータ型毎に出力 | 左記のほか、データ型毎のキー数とかも出ます、                                                                                   |
| --scan                    | カーソルを使って全部取得                                                   | scanで全件取得するときに便利。たぶん--partternとの併用が主な使い方                                                             |
| --pattern <pat>           | --scanで取得した結果を絞り込むことができる                                 | SCAN … MATCH のの部分を指定石ていることと同じ。「KEY全件から正規表現で絞り込む」みたいなことが可能                             |
| --intrinsic-latency <sec> | systemに備わっているレイテンシを計測                                       | 指定した秒数間起動する                                                                                                         |
| --eval <file>             | Luaスクリプトを使ってEVALコマンドを送る                                    | -                                                                                                                              |
| --help                    | ヘルプを表示                                                               | -                                                                                                                              |
| --version                 | バージョンを表示                                                           | -                                                                                                                              |

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

- redis serverに接続して対話的に実行

```lang:
$ redis-cli
127.0.0.1:6379> SET hoge bar
OK
```

- 引数を指定して非対話的に実行

```lang:
$ redis-cli -h localhost SET hoge bar
OK
```

- ファイルから読み込んで実行

```lang:
$ echo "SET hoge bar" >> set.txt
$ redis-cli < set.txt
OK
```

- リダイレクトを使用して実行

```lang:
$ echo "SET hoge bar" | redis-cli
OK
```

- 1行で複数のコマンドを実行

```lang:
$ echo -e "SET hoge bar \r\n GET hoge" | redis-cli
OK
"bar"
```

### Tips

- その１ : 区切り文字を「@」にして、mget

```lang:
$ redis-cli -d "@" --raw mget key:100 key:200
value:100@value:200
```

- その２ : 全キーからキーの下２文字が「00」であるものを検索

```lang:
$ redis-cli --scan --pattern "*00"
key:300
key:200
key:800
key:900
key:400
key:500
key:600
key:700
key:100
```

- その3 : その2リクエストを２秒間隔で３回実行する

```lang:
$ redis-cli -r 3 -i 2 get key:100
"value:100"
"value:100"
"value:100"
```

