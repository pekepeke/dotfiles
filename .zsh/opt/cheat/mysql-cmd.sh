mysqlcheck -u root -p --auto-repair --check --optimize --all-databases

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
pt-query-digest --type=tcpdump --group-by=tables --order-by=Query_time:cnt --limit=100 ~/work/tcpdump.txt &gt; ~/work/result.txt
# git://github.com/box/Anemometer.git

# 負荷テスト
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
