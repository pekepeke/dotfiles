## Basic Usage
### ObjectID生成規則
- 4バイトの，Unixエポックからの経過秒数(Unix時間)
- 3バイトのマシンID
- 2バイトのプロセスID
- 3バイトのカウンタ(開始番号はランダム)

```
52fcf106   0af12b     af9e         8d5bba
unix時間   マシンID   プロセスID   カウンタ

52fcf106(hex) -> 1418621566000(10) -> 2014/2/14 1:21:26
dt = new Date(); dt.setTime(parseInt("52fcf106",  16) * 1000); dt.toLocaleString()
// "2014/2/14 1:21:26"
```

### 基本コマンド

```
show dbs
use db
show collections
col = db[collectionName]

help
db.help()
col.help()
```

### ユーザ作成

```
use admin
# すべてのDBの管理権限をもつユーザーの作成
db.createUser({
	user: "username",
	pwd: "username",
	roles:[ {
		role: "userAdminAnyDatabase",
		db: "admin"
	} ]
})

# 特定のDBの管理者権限を持つユーザー
use [database]
db.createUser({
	user: "username",
	pwd: "username",
	roles:[ {
		role: "userAdminAnyDatabase", // "read", "readWrite"
		db: "database"
	} ]
})

db.addUser("read", "pwd", true)
db.addUser("readwrite", "pwd")

# delete user
db.system.users.remove({user: "username"})
```

### クエリ例

```
// 件数取得
col.count()
// find
col.find({"hoge": {$exists: true}})
col.find({"hoge.fuga": "piyo"})
// sort, limit
col.find({}).sort({$natural:-1}).limit(10)
col.find({}).sort({"hoge":-1}).offset(10).limit(10)
// 一部プロパティだけを取得
col.find({}, {_id:false, "user.screen_name":true, text:true }).sort({$natural:-1}).limit(10)
// 出力を加工
col.find({}).sort({$natural:-1}).limit(10).forEach( function(a){print(a.user.screen_name, ":",  a.text)} )
// プロパティなしドキュメントを表示
col.find({retweeted_status:{ $exists: false }}).sort({$natural:-1}).limit(5).forEach( function(a){print(a.user.screen_name, ":", a.text )} )
col.find( { retweeted_status:{$exists:false}, $where:"this.entities.hashtags.length < 2"  }).sort({$natural:-1}).limit(20).forEach( function(a){ print(a.user.screen_name, ':' , a.text); } )

// update
col.update({ "fuga" : "piyo" },  {$set: { "hoge": "aaa" }})
col.update({ "fuga" : "piyo" },  {$inc: { "count": 1 }})
```

## backup
### JSON を標準出力させてファイルに保存

```
echo 'shellPrint(db["collectionName"].find().limit(10)));' > query.js
mongo --quiet localhost:27017/dbName query.js > result.json
```

### backup & restore

```
mongodump -v --out ~/mongo_dump --db piyo
mongorestore -v --db [database_name] ~/mongo_dump/[database_name]
```

## 権限周り
- https://docs.mongodb.com/manual/reference/privilege-actions/

```
db.addUser({user:"fuga", pwd:"piyo", roles:["read"]})
db.addUser({user:"fuga", pwd:"piyo", roles:["readWrite"]})
```

### CRUD
- find
- insert
- remove
- update

### 管理権限
- changeCustomData
- changeOwnCustomData
- changeOwnPassword
- changePassword
- createCollection
- createIndex
- createRole
- createUser
- dropCollection
- dropRole
- dropUser
- emptycapped
- enableProfiler
- grantRole
- killCursors
- revokeRole
- unlock
- viewRole
- viewUser

### 管理・操作用権限
- authSchemaUpgrade
- cleanupOrphaned
- cpuProfile
- inprog
- invalidateUserCache
- killop
- planCacheRead
- planCacheWrite
- storageDetails

### レプリケーション管理・操作用権限

- appendOplogNote
- replSetConfigure
- replSetGetStatus
- replSetHeartbeat
- replSetStateChange
- resync

### シャード管理・操作用権限

- addShard
- enableSharding
- flushRouterConfig
- getShardMap
- getShardVersion
- listShards
- moveChunk
- removeShard
- shardingState
- splitChunk
- splitVector

### システム管理用権限

- applicationMessage
- closeAllDatabases
- collMod
- compact
- connPoolSync
- convertToCapped
- dropDatabase
- dropIndex
- fsync
- getParameter
- hostInfo
- logRotate
- reIndex
- renameCollectionSameDB
- repairDatabase
- setParameter
- shutdown
- touch

### システム調査用権限

- collStats
- connPoolStats
- cursorInfo
- dbHash
- dbStats
- diagLogging
- getCmdLineOpts
- getLog
- indexStats
- listDatabases
- listCollections
- listIndexes
- netstat
- serverStatus
- validate
- top

### シャード

```
use admin
// shard 追加
db.runCommand( { addshard : "localhost:10001" } );
db.runCommand( { addshard : "localhost:10002" } );
db.runCommand( { addshard : "localhost:10003" } );

// 追加したshardが正しく追加されているか確認
db.runCommand( { listshards : 1 } );
db.printShardingStatus();

// shard 有効化
db.runCommand( { enablesharding : "logdb" });

// shard 追加
use logdb
db.logs.createIndex( { month : 1 , uid : 1 } );

use admin
db.runCommand( { shardcollection : "logdb.logs" , key : { month : 1 , uid : 1 } } );

// 状態確認
sh.status(true);

```

## チューニング

### explain
```
```

key                    |説明
-----------------------|--------------------------------------------------------------------
cursor                 |カーソルタイプ。BasicCursor、BtreeCursor、GeoSearchCursorとか
isMultiKey             |マルチキーインデックスを使っているか
n                      |最終的にヒットしたドキュメント件数
nscannedObjects        |スキャンされたオブジェクトの数
nscanned               |スキャンされたオブジェクトorインデックスの数
nscannedObjectsAllPlans|すべてのクエリでスキャンされたオブジェクトの総数
nscannedAllPlans       |すべてのクエリでスキャンされたオブジェクトorインデックスの数
scanAndOrder           |インデックスを使わずに結果をソートして返すか
indexOnly              |クエリがインデックスのみを使っているか
nYields                |待っている書き込み処理を実行させるためにリードロックを解放した回数
nChunkSkips            |Chunkマイグレーション中にスキップしたドキュメント数
millis                 |クエリ実行時間(ミリ秒)
indexBounds            |インデックスを使って走査された要素の値の範囲(範囲検索なら上限と下限)

### インデックス
- http://blog.mknkisk.com/mongodb-3-index-explain/
```
db.collection.getIndexes()
db.collection.createIndex({nickname: 1})
db.collection.createIndex({nickname: 1}, {unique: true})
db.collection.createIndex({nickname: 1}, {background: true}) // background で作成
```

## 運用

### mongostat/mongotop
#### mongostat
- qr|qw の数値→運用中高負荷になったり、クエリーで、mongoに負荷を与えた場合 に発生しうる
	- この数値が上がるとクエリのタイムアウト、同期遅延等、様々な障害が発生しうる
- `--discover` オプションをつけるとレプリカセット・シャードクラスタの全てのインスタンス状態を表示してくれる

```
mongostat --discover
mongostat --discover -h localhost --port 27017 -u user -p --authenticationDatabase admin
// master だけ参照
mongostat --discover --host 192.168.0.200:27017 | grep M
```

#### mongotop
- コレクションごとに操作に利用した時間が表示される

```
mongotop -h localhost --port 27017 -u user -p --authenticationDatabase admin
```

#### シャーディング

```
// 追加
sh.addShard("localhost:27018")
// シャーディングの有効化
sh.enableSharding("db")
// シャードキーの設定
sh.shardCollection("db.users", {"_id": 1})
// 状態確認
sh.status()
// シャード状態を確認
db.printShardingStatus()
// 各シャードのDB/Collectionのデータサイズの推定値とオブジェクト数を確認(データ数が多くなると返却が非常に遅くなる)
printShardingSizes()
```

#### etc

```
// mongodb 全体の状態をリアルタイムに表示
db.serverStatus()
// あるDBに対する統計情報を表示
db.stats()
// 実行計画を表示
db.find().explain()
// 現在稼働中のオペレーションが見える
db.currentOp()
// クエリを kill
db.killOp(id)
// 60秒以上かかっているクエリを kill
db.currentOp().inprog.forEach(function(op) { if (op.secs_running > 60) { db.killOp(op.opid); }});
```

#### trouble shooting

障害                              |優先度|ツール                                   |監視内容
----------------------------------|------|-----------------------------------------|----------------------------------------------------------------
インデックスがうまく使われていない|高    |mongostat の idx miss<br>cursor.explain()|インデックスはメモリにのっているか<br>インデックスは使われているか
ロック解放待ちが多い              |高    |mongostat の Locked                      |ロック時間が稼働時間に対して大きくなっていないか
メモリにデータが載っていない      |高    |mongostat の res, faults                 |データ量が物理メモリを超えてページフォルトが発生していないか
ディスクが遅い                    |高    |コマンド(iostat など)                    |ディスクの処理時間は遅くないか
sync が多発                       |中    |mongostat の flushes                     |Sync が多発していないか
コレクションが肥大して再配置が多発|中    |db.collection.stats() の paddingFactor   |Padding_Factor は1より大きい値になっていないか
ディスク容量枯渇                  |中    |コマンド(dfなど)                         |ディクス容量が溢れないか
ネットワークリソースの枯渇        |低    |mongostat の conn<br>コマンド(netstat など)|コネクション数はTCPのソケット数の最大に達していないか
ネットワークIO待ちが多い          |低    |mongostatの netIn, netOut                |ネットワーク流量が回線の通信容量に迫っていないか
設定ミス、バグによるハング        |低    |mongodbのログ<br>コマンド(psなど)        |ログにエラーは出ていないか<br>プロセスは起動しているか

#### slow query memo

- locks(micros) rNNN: ロックがかかった時間(microseconds)
	- R - Global read lock
	- W - Global write lock
	- r - Database specific read lock
	- w - Database specific write lock
- Read-Write Lock
	- Read ロック中はReadのみOK
	- Write ロック中はRead/Write不可
