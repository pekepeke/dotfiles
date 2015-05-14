## 基本コマンド

```
show dbs
use db
show collections
col = db[collectionName]

help
db.help()
col.help()
```

## クエリ例

```
## 件数取得
col.count()
# sort, limit
col.find({}).sort({$natural:-1}).limit(10)
## 一部プロパティだけを取得
col.find({}, {_id:false, "user.screen_name":true, text:true }).sort({$natural:-1}).limit(10)
## 出力を加工
col.find({}).sort({$natural:-1}).limit(10).forEach( function(a){print(a.user.screen_name, ":",  a.text)} )
### プロパティなしドキュメントを表示
col.find({retweeted_status:{ $exists: false }}).sort({$natural:-1}).limit(5).forEach( function(a){print(a.user.screen_name, ":", a.text )} )
col.find( { retweeted_status:{$exists:false}, $where:"this.entities.hashtags.length < 2"  }).sort({$natural:-1}).limit(20).forEach( function(a){ print(a.user.screen_name, ':' , a.text); } )
```

## JSON を標準出力させてファイルに保存

```
echo 'shellPrint(db["collectionName"].find().limit(10)));' > query.js
mongo --quiet localhost:27017/dbName query.js > result.json
```

## backup & restore

```
mongodump -v --out ~/mongo_dump --db piyo
mongorestore -v --db [database_name] ~/mongo_dump/[database_name]
```

