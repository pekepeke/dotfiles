# dump
mysqldump --opt --skip-lock-tables --default-character-set=binary --hex-blob
mysqldump --opt --default-character-set=utf8 --hex-blob --all-databases > dump.sql
mysqldump -u root -p fuga --compact --opt --default-character-set=binary | gzip -c > $(date +'%Y%m%d').sql.gz
mysqldump -u root --all-databases --compact --opt --default-character-set=binary > dump.sql
mysqldump --single-transaction --skip-lock-tables --opt --flush-logs -u root -p > dump_$(date +'%Y%m%d').sql
mysqldump -uroot -pxxxxxxxx --flush-logs  --master-data=2 --opt --single-transaction --default-character-set=utf8 --hex-blob [db] > dump.sql

# create
mysqldump --no-data --compact schema > ~/db_new.sql
# data only
mysqldump --skip-extended-insert --add-drop-table=false -t --where '1 = 1'

