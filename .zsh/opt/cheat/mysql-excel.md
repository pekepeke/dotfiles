## テーブル存在チェック

```
=LEFT(A2, SEARCH(".", A2)-1)
=MID(A2, SEARCH(".", A2)+1, LEN(A2))
=IF(D1<>"", "UNION ALL ",  "")&"select '"&A2&"' name, COUNT(*) cnt from information_schema.tables WHERE table_schema = '"&B2&"' AND table_name = '"&C2&"'"
```
