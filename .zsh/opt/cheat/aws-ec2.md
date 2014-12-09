## EC2 ボリューム拡張
- EC2インスタンスを停止する
- EC2インスタンスのEBS Volume からスナップショットを作成
	- 現行の volume id をメモしておく
- スナップショットから Create Volume を実施する
	- volume id をメモしておく
- EC2 インスタンスから既存のEBS Volume をデタッチし、新しいEBS Volume をアタッチする(Volumes から実施)
	- デタッチ時に既存の /dev/xxx を確認しておく
- EC2 インスタンスを起動し resize2fs を実行

```
df -h
sudo resize2fs /dev/sda1
df -h
```

## swap ファイル作成

```
# sudo vim /etc/rc.local
SWAPFILENAME=/swap.img
MEMSIZE=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`

if [ $MEMSIZE -lt 2097152 ]; then
  SIZE=$((MEMSIZE * 2))k
elif [ $MEMSIZE -lt 8388608 ]; then
  SIZE=${MEMSIZE}k
elif [ $MEMSIZE -lt 67108864 ]; then
  SIZE=$((MEMSIZE / 2))k
else
  SIZE=4194304k
fi

# dd if=/dev/zero of=$SWAPFILENAME bs=1M count=50
fallocate -l $SIZE $SWAPFILENAME && mkswap $SWAPFILENAME && swapon $SWAPFILENAME
```

- fstab

```
/swap.img  swap   swap    defaults   0 0
```

## Locale 変更

```bash
sudo vi /etc/sysconfig/i18n
-----------
#LANG="en_US.UTF-8"
LANG="ja_JP.UTF-8"
-----------
```

## JSTに変更

```bash
sudo cp /usr/share/zoneinfo/Japan /etc/localtime
sudo vi /etc/sysconfig/clock
----------
ZONE="Asia/Tokyo"
UTC=False
----------
sudo /etc/init.d/crond restart
```

### swap をインスタンスストレージ上に作成

```bash
sudo rpm -ivh http://repo.classmethod.info/yum/x86_64/cm-repo-release-0.1.0-1.noarch.rpm
sudo yum install -y ec2-swap

vim /etc/sysconfig/ec2-swap

sudo reboot
```

