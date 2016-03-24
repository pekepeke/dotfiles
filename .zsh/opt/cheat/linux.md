
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
