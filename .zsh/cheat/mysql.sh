# average query time
mysqldumpslow -s at /var/log/mysql/mysql-slowquery.log
# average lock time
mysqldumpslow -s al /var/log/mysql/mysql-slowquery.log
# average rows sent
mysqldumpslow -s ar /var/log/mysql/mysql-slowquery.log
# select update
UPDATE table1 t1 ,table2 t2 SET t1.val1 = t2.val1 ,t1.val2 = t2.val2 ,t1.val3 = t2.val3 WHERE t1.id = t2.id;
