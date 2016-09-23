## mysqldump

```
# dump
mysqldump --opt --skip-lock-tables --default-character-set=binary --hex-blob
mysqldump --opt --default-character-set=utf8 --hex-blob --all-databases > dump.sql
mysqldump -u root -p fuga --compact --opt --default-character-set=binary | gzip -c > $(date +'%Y%m%d').sql.gz
mysqldump -u root --all-databases --compact --opt --default-character-set=binary > dump.sql
mysqldump --single-transaction --skip-lock-tables --opt --flush-logs -u root -p > dump_$(date +'%Y%m%d').sql
mysqldump -uroot -pxxxxxxxx --flush-logs  --master-data=2 --opt --single-transaction --default-character-set=utf8 --hex-blob [db] > dump.sql

# create
mysqldump --no-data --compact --skip-lock-tables --default-character-set=binary schema > db_new.sql
mysqldump --no-data --compact --skip-lock-tables --default-character-set=binary --databases schema1 schema2 > ddl.sql
mysqldump --no-data --compact --skip-lock-tables --default-character-set=binary --all-databases > ddl.sql
# data only
mysqldump --skip-extended-insert --add-drop-table=false -t --where '1 = 1'

```


## command

```
### ignore sql error
mysql -uroot -p -f dbname < ddl.sql

### check data file
mysqlcheck -u root -p --auto-repair --check --optimize --all-databases

### average query time
mysqldumpslow -s at /var/log/mysql/mysql-slowquery.log
### average lock time
mysqldumpslow -s al /var/log/mysql/mysql-slowquery.log
### average rows sent
mysqldumpslow -s ar /var/log/mysql/mysql-slowquery.log


## 負荷テスト
mysqlslap \
  --no-defaults \
  --concurrency=50 \
  --iterations=10 \
  --engine=innodb \
  --auto-generate-sql \
  --auto-generate-sql-add-autoincrement \
  --auto-generate-sql-load-type=mixed \
  --auto-generate-sql-write-number=1000 \
  --number-of-queries=100000 \
  --host=localhost \
  --port=3306 \
  --user=root
```

### diff

```
sudo aptitude install libsql-translator-perl -y
sudo yum install perl-SQL-Translator.noarch -y


mysqldump --no-data --compact -h[NEW_DB] -uUSER DB_NAME -d -p | sed -e 's/AUTO_INCREMENT=[0-9]\+//' > NEW_DB_schema.sql
mysqldump --no-data --compact -h[OLD_DB] -uUSER DB_NAME -d -p | sed -e 's/AUTO_INCREMENT=[0-9]\+//' > OLD_DB_schema.sql


sqlt-diff OLD_DB_schema.sql=MySQL NEW_DB_schema.sql=MySQL > diff.sql
```

## charcode

- `show variables like 'character_set%';
- `character_set_client` : クライアント側で発行した`sql`文はこの文字コードになる
- `character_set_connection` : クライアントから受け取った文字をこの文字コードへ変換する
- `character_set_database` : 現在参照しているDBの文字コード
- `character_set_results` : クライアントへ送信する検索結果はこの文字コードになる
- `character_set_server` : DB作成時のデフォルトの文字コード
- `character_set_system` : システムの使用する文字セット

`character_set_client` と `character_set_connection`, `character_set_results` で、 
この3変数はクライアントがクエリを送信し、 クエリ結果を受信するときのキャラクタセットとなる。
これを修正するのは SET NAMES [charset] で変更できる。

## クエリ調査

```
SHOW VARIABLES LIKE 'general_%';
SET GLOBAL general_log = 'ON';
SET GLOBAL general_log = 'OFF';
```

## テーブル、カラムの調査

```
select table_schema,  table_name from information_schema.tables WHERE table_name like '%%';
select table_schema,  table_name,  column_name from information_schema.columns WHERE table_name like '%%';
select table_schema,  table_name from information_schema.tables WHERE table_schema = '' AND table_name = '';
```

## sql
```
## select update
UPDATE table1 t1 ,table2 t2 SET t1.val1 = t2.val1 ,t1.val2 = t2.val2 ,t1.val3 = t2.val3 WHERE t1.id = t2.id;

## grant
GRANT ALL ON db.* TO user@'%' IDENTIFIED BY 'pass';
FLUSH PRIVILEGES;

## old password
SET SESSION old_passwords=0;

SHOW GRANTS FOR ユーザ名@localhost \G;
SHOW GRANTS FOR current_user();

## update character set
ALTER DATABASE databasename CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE tablename CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

## INDEX
ALTER TABLE hoge DROP INDEX IDX;
ALTER TABLE hoge ADD INDEX IDX (text);

CASE WHEN 条件 THEN 値1 ELSE 値2 END
```

## slowquery

```
# slow log 解析
mysqldumpslow -s t /tmp/test.log
#    -s al → 平均ロックタイムの長い順
#    -s ar → 平均行数の多い順
#    -s at → 平均実行時間の長い順
#    -s c → 総クエリ数の多い順
#    -s l → 総ロックタイムの長い順
#    -s r → 総行数の多い順
#    -s t → 総実行時間の長い順
mysqlsla --flat --slow ~mysql/var/mysql-slow.log --sort at

# pt-query-digest
pt-query-digest /var/log/mysql/mysql-slow.log
## pt-query-digest with processlist
pt-query-digest --processlist h=host,user=user,password=pass --output=slow.log
## pt-query-digest with tcpdump
tcpdump -s 65535 -x -nn -q -tttt -i bond0 -c 10000 port 3306 &gt; ~/work/tcpdump.txt
pt-query-digest --type=tcpdump --group-by=tables --order-by=Query_time:cnt --limit=100 ~/work/tcpdump.txt
# git://github.com/box/Anemometer.git

## テーブルごとのアクセス集計
mk-query-digest --type=tcpdump --group-by=tables --order-by Query_time:cnt --limit 100 tcpdump.out

## 特定のクエリのみ
mk-query-digest --type=tcpdump --filter '$event->{fingerprint} =~ m/^select/'  --order-by Query_time:cnt --limit 100 tcpdump.out > tcpdump.log

## commit/ping/connect を除いて集計
mk-query-digest --type=tcpdump --filter '$event->{fingerprint} !~ m/^(commit|admin|set)/' --limit 100 tcpdump.out > tcpdump.log

## 接続にかかった時間だけを抽出
mk-query-digest --type tcpdump --no-report --filter '$event->{fingerprint} =~ /Connect/ && printf "%.9f %s %s@%s\n", @{$event}{qw(Query_time host user db)}'

## 特定のテーブルだけをテーブルごとに
mk-query-digest --type=tcpdump --group-by=tables --order-by Query_time:cnt --limit 100  --filter 'grep /XXX/, @{$event->{tables}}' tcpdump.out

## pt-query-digest の見方
- Response：処理時間の合計
- Time：処理時間の合計の比率
- Calls：実行回数
- R/Call：平均処理時間
- Adpx：クエリの評価（1に近いほうがいい）
- EXPLAIN：EXPLAINのサマリ（TFは「Using temporary; Using filesort」、などなど）
- Item:簡略化されたクエリ
```
