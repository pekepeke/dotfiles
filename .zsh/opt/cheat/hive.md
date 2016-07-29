## hive
### CREATE TABLE

```
CREATE [EXTERNAL] TABLE [IF NOT EXISTS] テーブル名
[(項目名 型 [COMMENT コメント], …)]
[COMMENT テーブルのコメント]
[PARTITIONED BY (項目名 型 [COMMENT コメント], …)]
[CLUSTERED BY (項目名, …) [STORED BY (項目名 [ASC|DESC], …)] INTO バケット数 BUCKETS]
[ROW FORMAT 行フォーマット]
[
   STORED AS ファイルフォーマット]
 | STORED BY 'クラス名' [WITH SERDEPROPERTIES (～)]
]
[LOCATION パス]
[TBLPROPERTIES (プロパティー名=値, …)]
[AS SELECT文]
```

#### ROW FORMAT

```
ROW FORMAT DELIMITED
[ FIELDS TERMINATED BY ',']
[ COLLECTION ITEMS TERMINATED BY ':']
[ MAP KEYS TERMINATED BY '=']
[ LINES TERMINATED BY '\n']
```

#### STORED AS
- TEXTFILE : データをテキストファイルとして扱う
- SEQUENCEFILE : データをシーケンスファイル(Hadoop のもの)として扱う
- RCFILE
- InputFormat|OutputFormat クラス

```
STORED AS format;
```

### LOAD INTO
- LOCAL = ローカルファイル指定
- OVERWRITE = 上書き(ない場合はデータ追加)

```
LOAD DATA [LOCAL] INPATH 'path/to/file'
[OVERWRITE] INTO TABLE table
[PARTITION (column = 'value')]
```

### INSERT OVERWRITE

```
INSERT OVERWRITE TABLE table_name
[PARTITION (column = 'value')]
SELECT * FROM table WHERE xxx = 1
```

### INSERT INTO

```
INSERT INTO TABLE table_name
[PARTITION (column = 'value')]
SELECT * FROM table WHERE xxx = 1
```

### FROM INSERT

```
FROM 元テーブル名
INSERT｛OVERWRITE｜INTO｝TABLE テーブル名 [PARTITION (項目名=値, …)] SELECT文
INSERT｛OVERWRITE｜INTO｝TABLE テーブル名 [PARTITION (項目名=値, …)] SELECT文
```

### INSERT DIRECTORY
- インサート先をテーブルでなくディレクトリにする

```
FROM 元テーブル
INSERT OVERWRITE [LOCAL] DIRECTORY 'ディレクトリー' SELECT文
INSERT OVERWRITE [LOCAL] DIRECTORY 'ディレクトリー' SELECT文
```

### beeline

```
/usr/lib/hive/bin/beeline
!connect jdbc:hive2://localhost:10000 username password org.apache.hive.jdbc.HiveDriver
SHOW TABLES;

# NOSASL の場合
!connect jdbc:hive2://localhost:10000/default;auth=noSasl hiveuser pass org.apache.hive.jdbc.HiveDriver

beeline -u jdbc:hive2://localhost:10000 -e "select count(*) from test_tb" --verbose=true
```
