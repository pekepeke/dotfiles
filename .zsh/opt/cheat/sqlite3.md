sqlite3
=======

## create table

```
create table persons(id integer, name text);
create table users(
	id integer primary key autoincrement, 
	name text, 
	created_at DATETIME NOT NULL, 
	updated_at DATETIME NOT NULL
);
alter table aaa rename to bbb;
alter table aaa add column bbb integer;
create index users_idx1 on users(name);
create unique index users_idx2 on users(email);
drop index users_idx2;
```

## commands

```
## テーブル一覧表示
.table
.table %query%

## インデックス一覧
.indices
.indices ?table?

## テーブル定義の表示
.schema
.schema [table]

## VACUUM
VACUUM;
```
