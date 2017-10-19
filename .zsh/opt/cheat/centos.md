
## コンソールのビープ音消し
- /etc/inputrc に下記を追加

```
set bell-style none
```

## yum エラー

### centos のサポート切れ
- vault.centos.org に向けて、とりあえずエラーを凌ぐ
	- バージョンに何が指定できるかは http://vault.centos.org/ を参照すればOK

```
[base]
name=CentOS-$releasever - Base
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os # コメントアウト
baseurl=http://vault.centos.org/5.11/os/$basearch/ # vault.centos.org に設定
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#released updates
[updates]
name=CentOS-$releasever - Updates
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates # コメントアウト
baseurl=http://vault.centos.org/5.11/updates/$basearch/ # vault.centos.org に設定
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
#mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras # コメントアウト
baseurl=http://vault.centos.org/5.11/extras/$basearch/ # vault.centos.org に設定
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
```

## S.M.A.R.T. 情報参照

```
yum -y install smartmontools
smartctl -i /dev/hda
```

## Docker install

```
# https://docs.docker.com/engine/installation/linux/docker-ce/centos/
sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum install docker-ce
```

## memotitle
### 参考記事など
- https://www.sssg.org/blogs/naoya/archives/1144
