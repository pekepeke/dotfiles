mysqlcheck -u root -p --auto-repair --check --optimize --all-databases


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
