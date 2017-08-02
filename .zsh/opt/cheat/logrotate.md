
### test

```
# dry-run 実行
logrotate -df /etc/logrotate.d/mysql-log-rotate
```

### mysql
- /root/.my.cnf, cron.d のHOME 設定が必要かも

$ vim /etc/logrotate.d/mysql-log-rotate
```
/var/log/mysql/error.log /var/log/mysql/slow.log {
    create 644 mysql mysql
    notifempty
    daily
    rotate 14
    missingok
    nocompress
    dateext
    sharedscripts
    postrotate
    # just if mysqld is really running
    if test -x /usr/bin/mysqladmin && \
       /usr/bin/mysqladmin ping &>/dev/null
    then
       /usr/bin/mysqladmin flush-logs
    fi
    endscript
}
```

### iptables

```
/var/log/iptables-dnsamp.log /var/log/iptables-forward-drop.log /var/log/iptables-input-drop.log /var/log/iptables-ping-attack.log {
     weekly
     rotate 4
     create
     postrotate
          /etc/init.d/iptables reload > /dev/null 2> /dev/null || true
     endscript
}
```
