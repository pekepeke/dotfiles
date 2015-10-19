MySQL Trouble
=============

## server status

```
SHOW GLOBAL STATUS;
```

変数                          |説明                                                                                        
------------------------------|--------------------------------------------------------------------------------------------
Aborted_clients               |接続を適切に閉じないままクライアントが終了したことが原因で中断した接続の数。                
Aborted_connects              |MySQLサーバに接続しようとして失敗した回数。                                                 
Bytes_received                |すべてのクライアントから受信したバイト数。                                                  
Bytes_sent                    |すべてのクライアントへ送信したバイト数。                                                    
Connections                   |(成功/不成功に関わらず) MySQL サーバへの接続試行回数。                                      
Delayed_errors                |エラー発生（duplicate key の可能性）により、INSERT DELAYED で書き込まれたレコードの数。     
Innodb_buffer_pool_pages_free |空き容量                                                                                    
Innodb_data_pending_reads     |現在の読み込み保留の数。                                                                    
Innodb_data_pending_writes    |現在の書き込み保留の数。                                                                    
Innodb_data_read              |ここまでのデータの読み込み量 (単位:バイト)。                                                
Innodb_rows_deleted           |InnoDB テーブルから削除したレコード数。                                                     
Innodb_rows_inserted          |InnoDB テーブルへの挿入レコード数。                                                         
Innodb_rows_read              |InnoDB テーブルからの読み込みレコード数。                                                   
Innodb_rows_updated           |InnoDB テーブルでの更新レコード数。                                                         

クエリキャッシュヒット率=`Qcache_hits` / (`Qcache_hit` + `COM_select`)
クエリキャッシュヒット率が6割以下の場合は全体的に見直しをしたほうがよさげ

## 便利コマンド

コマンド              |説明                                
----------------------|------------------------------------
SHOW PROCESSLIST      |接続されているスレッドの一覧        
SHOW OPEN TABLES      |現在オープンされているテーブルの一覧
SHOW PROCEDURE STATUS |ストアドプロシージャの一覧          
SHOW GRANTS           |ユーザー権限一覧                    
SHOW WARNINGS         |クエリで発生した警告一覧            
SHOW ERRORS           |クエリで発生したエラー一            

## とりあえず SHOW PROCESSLIST

```
SHOW PROCESSLIST \G;
```

- Time と State に注目する。
	- やたらとTime が長いまま、`SendingData`などの`Sleep`以外のStateになっているプロセスはSQLが問題なっていることが多い(らしい)。
	- State に Locked とあればロックされてしまっているので、Time = クエリの実行時間 = ロック時間となるので、あまりにも長い時間のものがあれば、要改修。
	- Sleep はロック解除待ちをしている時間。


## プロファイリング情報

```
SET profiling = 1;
SHOW PROFILE;
```

## クエリログ有効化

```
-- ファイル出力
SET GLOBAL general_log='on';
-- テーブル出力(mysql.general_log)
SET GLOBAL log_output = 'table';
-- 設定OFF
SET GLOBAL general_log = 'off';
```

## 実行計画の詳細表示

```
EXPLAIN EXTENDED [query] \G;
```

warining があれば `show warnings \G` を実行して、最適化後に実行されるクエリを確認して、ボトルネックがないかを確認する。

