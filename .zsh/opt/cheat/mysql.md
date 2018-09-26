## mysqldump

| オプション | 説明 |
| ---------- | ---- |
| --opt | `--add-drop-table --add-locks --create-options --disable-keys --extended-insert --lock-tables --quick --set-charset`と同じ。デフォルトでこのオプションは有効。 |
| --add-drop-table | DROP TABLE文を含める |
| --add-locks | 各テーブルへのINSERT文の前後にLOCK_TABLES文とUNLOCK TABLES文を含める。インポートの速度が向上する。 |
| --create-options | CREATE TABLE文にMySQL特有のオプションを含める |
| --disable-keys | 各テーブルについて、全てのレコードのインポートが完了するまでインデックスを作らないようにする。インポートの速度向上が期待できるが、MyISAMテーブルの(UNIQUEではない)通常のインデックスにしか効果が無い。 |
| --extended_insert | INSERT文をコンパクトな書式でダンプする。ダンプファイルのサイズが小さくなる。インポートの時間も短縮する。 |
| --lock-tables | ダンプの前にDBの全テーブルをロックする。ただし、ロックはDBごとに行われるのでDB間でのデータ整合性は保証されない。InnoDBでは`--single-transaction`を使った方が速い。 |
| --skip-lock-tables | --lock-tablesオプションを無効にする。--optが--lock-tablesを有効にするので、それを打ち消す為に使用する。 |
| --quick | ダンプ時にテーブルの全レコードをメモリに一旦バッファする代わりに、1行ずつ読み込んでダンプする。データ量の大きなテーブルのダンプ時にメモリを圧迫しなくて済む。 |
| --set-charset | SET NAMES文を出力する。 |
| --quote-names | DB名、テーブル名、カラム名などの識別子をバックティック文字で囲む。これらの識別子にMySQLの予約後が含まれていても問題なく動作するようになる |
| --single-transaction | ダンプ処理をトランザクションで囲む。データの整合性を保つのに有効だが、MyISAMテーブルが含まれるDBでは意味が無いので、代わりに--lock-tablesか--lock-all-tablesを使う。 |
| --flush-logs | バイナリログをフラッシュして、新しいファイルを作る。フラッシュ |
| --lock-all-tables | ダンプの開始から完了まで、全データベースの全テーブルをロックする。これを使うと自動的に`--single-transaction`と`--lock-tables`オプションはオフになる。 |
| --master-data[=2] | `CHANGE MASTER TO`句を含める。これによってレプリケーションのスレーブサーバがマスターサーバのバイナリログの読み取り開始ポイントを知ることが出来る。このオプションは`--lock-all-tables`を オンにする。ただし、`--single-transaction`がオンの場合はそうはならず、代わりにダンプ開始時に一瞬だけグローバルリードロックされる。`=2`を付けた場合はバイナリログの読み出し開始位置をコメントとして出力する。これは人間が参考のために見たいときに使う。 |
| --password | MySQLサーバに接続する時のパスワード |


```
# dump
mysqldump --opt --skip-lock-tables --default-character-set=binary --hex-blob
mysqldump --opt --default-character-set=utf8 --hex-blob --all-databases > dump.sql
mysqldump -u root -p fuga --compact --opt --default-character-set=binary | gzip -c > $(date +'%Y%m%d').sql.gz
mysqldump -u root --all-databases --compact --opt --default-character-set=binary > dump.sql
mysqldump --single-transaction --skip-lock-tables --opt --flush-logs -u root -p > dump_$(date +'%Y%m%d').sql
mysqldump -uroot -pxxxxxxxx --flush-logs  --master-data=2 --opt --single-transaction --default-character-set=utf8 --hex-blob [db] > dump.sql
mysqldump -uroot -pxxxxxxxx --flush-logs  --master-data=2 --opt --single-transaction --default-character-set=utf8 --hex-blob [db] [tbl1] [tbl2] > dump.sql

# create
mysqldump --no-data --compact --skip-lock-tables --default-character-set=binary schema > db_new.sql
mysqldump --no-data --compact --skip-lock-tables --default-character-set=binary --databases schema1 schema2 > ddl.sql
mysqldump --no-data --compact --skip-lock-tables --default-character-set=binary --all-databases > ddl.sql
# data only
mysqldump --skip-extended-insert --add-drop-table=false -t --where '1 = 1'
mysqldump --complete-insert --skip-extended-insert --add-drop-table=false -t --where '1 = 1'
mysqldump --quote-names --skip-lock-tables --complete-insert --skip-extended-insert --no-create-info --no-create-db --add-drop-table=false

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

## 一括削除

```
SELECT CONCAT('TRUNCATE TABLE ', table_schema, '.', table_name, ';') FROM information_schema.tables WHERE table_schema IN ('hogedb');
```

## テーブル、カラムの調査

```
SELECT table_schema,  table_name FROM information_schema.tables WHERE table_name like '%%';
SELECT table_schema,  table_name FROM information_schema.tables WHERE table_schema = '' AND table_name = '';
SELECT * FROM information_schema.tables WHERE table_schema NOT IN ('information_schema', 'test') AND table_name like '%';

SELECT table_schema,  table_name,  column_name FROM information_schema.columns WHERE table_name like '%%';
SELECT * FROM information_schema.columns WHERE table_schema NOT IN ('information_schema', 'test') AND column_name like '%';
SELECT * FROM information_schema.columns WHERE table_schema NOT IN ('information_schema', 'test') AND table_name like '%' AND column_name like '%';
```

## grant 調査

```
SELECT CONCAT('GRANT ',  GROUP_CONCAT(DISTINCT privilege_type),  ' ON ',  table_schema,  '.* TO ',  grantee,  ';') AS grant_sql FROM information_schema.schema_privileges GROUP BY grantee,  table_schema
SELECT CONCAT('GRANT ',  GROUP_CONCAT(DISTINCT privilege_type),  ' ON *.* TO ',  grantee,  ';') AS grant_sql FROM information_schema.user_privileges GROUP BY grantee
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

# スロークエリ集計
pt-query-digest --group-by fingerprint --order-by Query_time:sum mysql-slowquery.log.2018-09-03.09
# -–attribute-value-limit を使って大きすぎる実行時間のクエリを無視する
pt-query-digest --group-by fingerprint --order-by Query_time:sum --attribute-value-limit=4294967296 mysql-slowquery.log.2018-09-03.09

# qtime, cnt で集計
pt-query-digest --limit 50 --order-by Query_time:sum --since YYYY-MM-DD 00:00:00 --until YYYY-MM-DD 23:59:59 slow.log > YYYY-MM-DD_by_qtime.txt
pt-query-digest --limit 50 --order-by Query_time:cnt --since YYYY-MM-DD 00:00:00 --until YYYY-MM-DD 23:59:59 slow.log > YYYY-MM-DD_by_count.txt

pt-query-digest /var/log/mysql/mysql-slow.log
## pt-query-digest with processlist
pt-query-digest --processlist h=host,user=user,password=pass --output=slow.log
## pt-query-digest with tcpdump
tcpdump -s 65535 -x -nn -q -tttt -i bond0 -c 10000 port 3306 &gt; ~/work/tcpdump.txt
pt-query-digest --type=tcpdump --group-by=tables --order-by=Query_time:cnt --limit=100 ~/work/tcpdump.txt
# git://github.com/box/Anemometer.git

## テーブルごとのアクセス集計
pt-query-digest --type=tcpdump --group-by=tables --order-by Query_time:cnt --limit 100 tcpdump.out

## 特定のクエリのみ
pt-query-digest --type=tcpdump --filter '$event->{fingerprint} =~ m/^select/'  --order-by Query_time:cnt --limit 100 tcpdump.out > tcpdump.log

## commit/ping/connect を除いて集計
pt-query-digest --type=tcpdump --filter '$event->{fingerprint} !~ m/^(commit|admin|set)/' --limit 100 tcpdump.out > tcpdump.log

## 接続にかかった時間だけを抽出
pt-query-digest --type tcpdump --no-report --filter '$event->{fingerprint} =~ /Connect/ && printf "%.9f %s %s@%s\n", @{$event}{qw(Query_time host user db)}'

## 特定のテーブルだけをテーブルごとに
pt-query-digest --type=tcpdump --group-by=tables --order-by Query_time:cnt --limit 100  --filter 'grep /XXX/, @{$event->{tables}}' tcpdump.out

## show processlistから読み込む
pt-query-digest --processlist h=localhost,u=root,p=password --run-time 60

## バイナリログから読み込む
mysqlbinlog mysql-bin.000203 > /tmp/binlog.log

## generalログ

pt-query-digest --type genlog general.log

## スロークエリログ
pt-query-digest --type slowlog slow.log

## tcpdump
tcpdump -s 65535 -x -nn -q -tttt -i any -c 1000 port 3306 mysql.tcpdump
pt-query-digest --type tcpdump mysql.tcpdump

## 解析時のオプションでEXPLAINを実行
pt-query-digest --type slowlog --explain h=localhost,u=root XXXX-slow.log

## --reviewオプション
### --reviewオプション付きでクエリを解析にかけると、DSNで指定したMySQLにデータが保存され、レビュー済に更新した場合、レポートの対象外クエリとなる
### update query_review set reviewed_by="user",reviewed_on = now() where checksum=8858001711021306865;
pt-query-digest --review h=localhost,u=root --no-report slow.log

## pt-query-digest の見方
- Response：処理時間の合計
- Time：処理時間の合計の比率
- Calls：実行回数
- R/Call：平均処理時間
- Adpx：クエリの評価（1に近いほうがいい）
- EXPLAIN：EXPLAINのサマリ（TFは「Using temporary; Using filesort」、などなど）
- Item:簡略化されたクエリ
```

## partition

```
SHOW VARIABLES LIKE '%PARTITION%' ;

# 5.5未満
ALTER TABLE sample_tables
PARTITION BY RANGE (TO_DAYS(date)) (
    PARTITION p201601 VALUES LESS THAN (TO_DAYS('2016/02/01 00:00:00')),
    PARTITION p201602 VALUES LESS THAN (TO_DAYS('2016/03/01 00:00:00')),
    PARTITION p201603 VALUES LESS THAN (TO_DAYS('2016/04/01 00:00:00')),
    PARTITION p201604 VALUES LESS THAN (TO_DAYS('2016/05/01 00:00:00')),
    PARTITION p201605 VALUES LESS THAN (TO_DAYS('2016/06/01 00:00:00')),
    PARTITION p201606 VALUES LESS THAN (TO_DAYS('2016/07/01 00:00:00')),
    PARTITION p201607 VALUES LESS THAN (TO_DAYS('2016/08/01 00:00:00')),
    PARTITION p201608 VALUES LESS THAN (TO_DAYS('2016/09/01 00:00:00')),
    PARTITION p201609 VALUES LESS THAN (TO_DAYS('2016/10/01 00:00:00')),
    PARTITION p201610 VALUES LESS THAN (TO_DAYS('2016/11/01 00:00:00')),
    PARTITION p201611 VALUES LESS THAN (TO_DAYS('2016/12/01 00:00:00')),
    PARTITION p201612 VALUES LESS THAN (TO_DAYS('2017/01/01 00:00:00')),
    PARTITION p201701 VALUES LESS THAN (TO_DAYS('2017/02/01 00:00:00')),
    PARTITION p201702 VALUES LESS THAN (TO_DAYS('2017/03/01 00:00:00')),
    PARTITION p201703 VALUES LESS THAN (TO_DAYS('2017/04/01 00:00:00')),
    PARTITION p201704 VALUES LESS THAN (TO_DAYS('2017/05/01 00:00:00')),
    PARTITION p201705 VALUES LESS THAN (TO_DAYS('2017/06/01 00:00:00')),
    PARTITION p201706 VALUES LESS THAN (TO_DAYS('2017/07/01 00:00:00')),
    PARTITION p201707 VALUES LESS THAN (TO_DAYS('2017/08/01 00:00:00')),
    PARTITION p201708 VALUES LESS THAN (TO_DAYS('2017/09/01 00:00:00')),
    PARTITION p201709 VALUES LESS THAN (TO_DAYS('2017/10/01 00:00:00')),
    PARTITION p201710 VALUES LESS THAN (TO_DAYS('2017/11/01 00:00:00')),
    PARTITION p201711 VALUES LESS THAN (TO_DAYS('2017/12/01 00:00:00')),
    PARTITION p201712 VALUES LESS THAN (TO_DAYS('2018/01/01 00:00:00'))
);
# 5.5 以降
ALTER TABLE sample_tables
PARTITION BY RANGE COLUMNS(date) (
    PARTITION p201303 VALUES LESS THAN ('2013-04-01 00:00:00'),
    PARTITION p201304 VALUES LESS THAN ('2013-05-01 00:00:00'),
    PARTITION p201305 VALUES LESS THAN ('2013-06-01 00:00:00'),
    PARTITION p201306 VALUES LESS THAN ('2013-07-01 00:00:00')
);

# add partition
CREATE TABLE IF NOT EXISTS `test_log_1000000` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`type` tinyint(1) NOT NULL,
`created` datetime NOT NULL,
PRIMARY KEY (`id`,`type_code`),
);

ALTER TABLE test_log_1000000
PARTITION BY RANGE columns(type) (
PARTITION p_type_code0 VALUES LESS THAN (1) ENGINE = InnoDB,
PARTITION p_type_code1 VALUES LESS THAN (2) ENGINE = InnoDB,
PARTITION p_type_code2 VALUES LESS THAN (3) ENGINE = InnoDB,
PARTITION p_type_code3 VALUES LESS THAN (4) ENGINE = InnoDB,
PARTITION p_type_code4 VALUES LESS THAN (5) ENGINE = InnoDB,
PARTITION p_type_code5 VALUES LESS THAN (6) ENGINE = InnoDB,
PARTITION pmax VALUES LESS THAN MAXVALUE

# drop
ALTER TABLE test_log_1000000 DROP PARTITION p_type_code5;

# alter
ALTER TABLE test_log_1000000 REORGANIZE PARTITION pmax INTO (
PARTITION p_type_code5 VALUES LESS THAN (6),
PARTITION pmax VALUES LESS THAN MAXVALUE);

# remove
ALTER TABLE test_log_1000000 REMOVE PARTITIONING;
```

## OS側のチューニング

```
http://www.jonathanlevin.co.uk/2018/02/my-mysql-linux-tuning-checklist.html
 Things I look for when optimising or debugging a Linux OS:

    IOschedular (noop or deadline)
    Linux Kernel > 3.18 (multi queuing)
    IRQbalance > 1.0.8
    File System: noatime, nobarrier
        ext4: data=ordered
        xfs: 64k
        logfiles in different partition (if possible)
    Swapiness
    Jemalloc (if needed)
    Transparent hugepages
    Ulimit (open files)
    Security
        IPtables
        PAM security
```
