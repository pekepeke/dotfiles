## format

```
# 分・時・日・月・曜日・コマンド
00    3  1  7  * echo 7/1 3:00
00   10  *  *  1 echo Mon 10:00
*/10  *  *  *  * echo every 10 minutes
30  4,9  *  *  * every 4:30, 9:30

55 23 28-31 * * /usr/bin/test $( date -d '+1 day' +%d ) -eq 1 && echo last day of month
0 0 * * 5 /usr/bin/test $( date '+\%m' ) -ne $( date -v+7d '+\%m' ) && echo 'last friday of month'
MAILTO="" # do not send mail
```

## set from file

```
crontab cron.txt
```

## cron と同じ状態で実行
### crontab に追加

```
* * * * * env > ~/cron_env
```

### cat cron_env

```
SHELL=/bin/sh
USER=vagrant
PATH=/usr/bin:/bin
PWD=/home/vagrant
SHLVL=1
HOME=/home/vagrant
LOGNAME=vagrant
_=/usr/bin/env
```

### 実行

```
env - `cat ~/cron_env` /path/to/script.rb
```

### 環境変数空で実行

```
env - /path/to/script.rb
```

