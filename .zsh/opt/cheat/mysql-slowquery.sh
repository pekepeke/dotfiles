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
