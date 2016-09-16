debian memo
===========

### サービス管理

```
update-rc.d <service> defaults
update-rc.d <service> start 20 3 4 5
update-rc.d <service> disable
update-rc.d -f <service>  remove
```

```
sudo apt-get install sysv-rc-conf
sysv-rc-conf --list
sysv-rc-conf apache2 on
sysv-rc-conf apache2 off
sysv-rc-conf --list apache2
```


### locale
- aptでlanguage-packを追加する

```
apt-get install language-pack-ja
```

- locale-genする

```
locale-gen ja_JP.UTF-8
update-locale LANG=ja_JP.UTF-8
```

### timezone

```
cp -p /etc/localtime /etc/localtime.org
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```
