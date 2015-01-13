## 文字コード変更

character_set_client      utf-8
character_set_connection  utf-8
character_set_database    utf-8
character_set_results     utf-8
character_set_server      utf-8
skip-character-set-client-handshake 1

## timezone 変更(init_connect)

-- SET SESSION time_zone = CASE WHEN POSITION('rds' IN CURRENT_USER()) = 1 THEN 'UTC' ELSE 'Asia/Tokyo' END;
SET SESSION time_zone = CASE WHEN POSITION('rdsadmin@' IN CURRENT_USER()) = 1 THEN 'UTC' ELSE 'Asia/Tokyo' END;

## timezone 変更(stored procedure + init_connect)

### define stored procedure

DELIMITER |
CREATE PROCEDURE shared.`store_time_zone`()
IF NOT (POSITION('rdsadmin@' IN CURRENT_USER()) = 1) THEN
  SET SESSION time_zone = 'Asia/Tokyo';
END IF |
DELIMITER ;

### 動作確認

select now();
CALL shared.store_time_zone;
select now();

### init_connect に設定

CALL shared.store_time_zone
