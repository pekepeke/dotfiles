# my.cnf
- https://www.fromdual.com/mysql-configuration-file-sample

```
[client]
port        = 3306
# socket      = /var/run/mysqld/mysqld.sock

[mysqld_safe]
# socket      = /var/run/mysqld/mysqld.sock
nice        = 0

[mysqld]
# user        = mysql
# pid-file    = /var/run/mysqld/mysqld.pid
# socket      = /var/run/mysqld/mysqld.sock
# port        = 3306
# basedir     = /usr
# datadir     = /var/lib/mysql
# tmpdir      = /tmp
# lc-messages-dir = /usr/share/mysql

#skip-external-locking
#bind-address       = 127.0.0.1
default_storage_engine         = InnoDB
# explicit_defaults_for_timestamp = 1                                  # MySQL 5.6, test carefully! This can have an impact on application.
# disable_partition_engine_check  = true                               # Since MySQL 5.7.17 to 5.7.20. To get rid of nasty message in error log

# character_set_server           = utf8mb4                                # If you prefer utf8
# collation_server               = utf8mb4_general_ci

# max_connections                = 505                                 # Values < 1000 are typically good
# max_user_connections           = 500                                 # Limit one specific user/application
# thread_cache_size              = 505

# Fine Tuning
key_buffer_size      = 8M # 16M
max_allowed_packet  = 16M
thread_stack        = 192K
thread_cache_size       = 8

# This replaces the startup script and checks MyISAM tables if needed
# the first time they are touched
myisam-recover-options         = BACKUP
#max_connections        = 100
#table_cache            = 64
#thread_concurrency     = 10

# Query Cache Configuration
query_cache_type    = 1
query_cache_limit   = 1M
query_cache_size        = 16M

# Session variables
sort_buffer_size               = 2M                                  # Could be too big for many small sorts
tmp_table_size                 = 32M                                 # Make sure your temporary results do NOT contain BLOB/TEXT attributes
read_buffer_size               = 128k                                # Resist to change this parameter if you do not know what you are doing
read_rnd_buffer_size           = 256k                                # Resist to change this parameter if you do not know what you are doing
join_buffer_size               = 128k                                # Resist to change this parameter if you do not know what you are doing

# Other buffers and caches
table_definition_cache         = 1400                                # As big as many tables you have
table_open_cache               = 2000                                # connections x tables/connection (~2)
table_open_cache_instances     = 16

# Logging and Replication
#general_log_file        = /var/log/mysql/mysql.log
#general_log             = 1

# Error log - should be very few entries.
log_error = /var/log/mysql/error.log
#log_slow_queries   = /var/log/mysql/mysql-slow.log
#long_query_time = 0.5
#log-queries-not-using-indexes
#slow_query_log                 = 0
#long_query_time                = 0.5
#min_examined_row_limit         = 100

# The following can be used as easy to replay backup logs or for replication.
# note: if you are setting up a replication slave, see README.Debian about
#       other settings you may need to change.
#server-id      = 1
#log_bin            = /var/log/mysql/mysql-bin.log
# expire_logs_days    = 10
# max_binlog_size         = 100M
#binlog_do_db       = include_database_name
#binlog_ignore_db   = include_database_name

# Slave variables
# log_slave_updates              = 1                                   # Use if Slave is used for Backup and PiTR
# read_only                      = 0                                   # Set to 1 to prevent writes on Slave
# super_read_only                = 0                                   # Set to 1 to prevent writes on Slave for users with SUPER privilege. Since 5.7
# skip_slave_start               = 1                                   # To avoid start of Slave thread
# relay_log                      = <hostname>-relay-bin
# relay_log_info_repository      = table                               # MySQL 5.6
# master_info_repository         = table                               # MySQL 5.6
# slave_load_tmpdir              = '/tmp'

# InnoDB
innodb_buffer_pool_size = 128M # 1G  # about 70% of RAM
innodb_buffer_pool_instances = 1 #16
innodb_file_per_table = ON

# innodb_flush_method            = O_DIRECT                            # O_DIRECT is sometimes better for direct attached storage
# innodb_write_io_threads        = 8                                   # If you have a strong I/O system or SSD
# innodb_read_io_threads         = 8                                   # If you have a strong I/O system or SSD
# innodb_io_capacity             = 1000                                # If you have a strong I/O system or SSD

innodb_flush_log_at_trx_commit = 2                                   # 1 for durability, 0 or 2 for performance
innodb_log_buffer_size         = 8M                                  # Bigger if innodb_flush_log_at_trx_commit = 0
innodb_log_file_size           = 256M                                # Bigger means more write throughput but longer recovery time
# innodb_log_buffer_size = 64M
# innodb_log_file_size = 2G

# * Security Features
# chroot = /var/lib/mysql/

# For generating SSL certificates I recommend the OpenSSL GUI "tinyca".
# ssl-ca=/etc/mysql/cacert.pem
# ssl-cert=/etc/mysql/server-cert.pem
# ssl-key=/etc/mysql/server-key.pem



[mysqldump]
quick
quote-names
max_allowed_packet  = 16M

[mysql]
#no-auto-rehash # faster start of mysql but no tab completition
max_allowed_packet             = 16M
prompt                         = '\u@\h [\d]> '
default_character_set          = utf8mb4

[isamchk]
key_buffer_size      = 16M
```
