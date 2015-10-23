## テーブル、カラムの調査

```
select table_schema,  table_name from information_schema.tables WHERE table_name like '%%';
select table_schema,  table_name,  column_name from information_schema.columns WHERE table_name like '%%';
select table_schema,  table_name from information_schema.tables WHERE table_schema = '' AND table_name = '';
```

