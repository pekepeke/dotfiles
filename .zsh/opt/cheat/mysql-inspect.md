## charcode

- `show variables like 'character_set%';
- `character_set_client` : クライアント側で発行した`sql`文はこの文字コードになる
- `character_set_connection` : クライアントから受け取った文字をこの文字コードへ変換する
- `character_set_database` : 現在参照しているDBの文字コード
- `character_set_results` : クライアントへ送信する検索結果はこの文字コードになる
- `character_set_server` : DB作成時のデフォルトの文字コード
- `character_set_system` : システムの使用する文字セットで常に`utf8`が使用されている

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

