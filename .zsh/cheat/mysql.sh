# average query time
mysqldumpslow -s at /var/log/mysql/mysql-slowquery.log
# average lock time
mysqldumpslow -s al /var/log/mysql/mysql-slowquery.log
# average rows sent
mysqldumpslow -s ar /var/log/mysql/mysql-slowquery.log

