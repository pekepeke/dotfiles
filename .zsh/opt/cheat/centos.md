
## コンソールのビープ音消し
- /etc/inputrc に下記を追加

```
set bell-style none
```

## network, ifcfg-ethX
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/ch-The_sysconfig_Directory#s2-sysconfig-network
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/s1-networkscripts-interfaces

【項目の意味】
- DEVICE="eth0" ←対象のNIC
- BOOTPROTO="static" ←自動で取得したいときは、"dhcp"とする。固定させたい時は、"static"か"none"とする。

以下の４つは、BOOTPROTO="static"にした時だけ記述。(自動で取得する際は不要。DHCPで取得される。)
- BROADCAST=192.168.0.255 ←ブロードキャストアドレス。
- IPADDR=192.168.0.254 ←自分のIPアドレス
- NETMASK=255.255.255.0 ←自分が所属しているネットワークのサブネットマスク。
- NETWORK=192.168.0.0 ←自分が所属しているネットワーク
- NM_CONTROLLED="yes" ←GUIでネットワーク設定を行うかどうかの設定。(yesならGUIでネットワーク設定ができる。)※GUIでネットワーク設定を行うツール：NetworkManager
- ONBOOT=yes ←OS起動時にNICを起動させるかどうか。(yesなら起動させる。)
- TYPE="Ethernet" ←通信の規格。他には、"Tokenling"もある。
- UUID="ca822639-5e60-4583-a26b-d35013736438" ←CentOSが付与する、NICの識別名。(CentOSはこれを見るらしい)
- HWADDR=08:00:27:3C:94:EF ←MACアドレス
- DEFROUTE=yes ←デフォルトのNIC(複数のNICが接続されている時に意味を持つ。)
- PEERDNS=no ←DHCPサーバからDNSの情報を取得し、/etc/resolv.confの内容を書き換える。自分が用意したDNSを使う等DNSサーバのアドレスを固定したいときはnoにすると、/etc/resolv.confは書き換わらない。
- PEERROUTES=no ←DHCPサーバからルーターの情報を取得し、/etc/sysconfig/networkの内容を書き換える。noにすれば、自分で設定した/etc/sysconfig/networkの内容は変わらない。(嘘だったらごめん・・・。)
- IPV4_FAILURE_FATAL=yes ←IPv4の設定がうまくいかなかった時、IPv6が使えるのなら使うか？それとも使用できても使わないか？(yesなら使わない。noなら使う)
- IPV6INIT=no ←IPv6を使用するかどうか。(yesなら使う。)
- NAME="System eth0" ←GUIでネットワーク設定を行う際に表示されるNICの名前。
- NETWORKING=yes ←ネットワーク機能を使用するかどうか。
- HOSTNAME=tomcat ←ホスト名(これはインストール時に設定される。)
- GATEWAY=192.168.0.1 ←ルーターのアドレス。
- FORWARD_IPV4=no ←パケットを転送するかどうか。(自分をルーターにするときは、yesにする。)


## python 関連
### pip の導入

```
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```

## DNF

```
https://dnf.readthedocs.io/en/latest/cli_vs_yum.html

/etc/dnf/dnf.conf
/etc/yum.repos.d/

DNF本体に同梱
yum-fastestmirror
初期状態では有効化されておらず、 /etc/dnf/dnf.conf の[main]セクションにfastestmirror=trueを追加することによって有効化される。

yum-priorities
リポジトリ設定でpriorityを設定すれば利用できる。

yum-downloadonly
DNFではdnf-plugins-coreに収録されるプラグインとなった。
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

## centos7

```
timedatectl set-timezone Asia/Tokyo
localectl set-locale LANG=ja_JP.utf8
```

### chrony
https://qiita.com/yunano/items/7883cf295f91f4ef716b

```
server ntp.nict.jp iburst
server 0.jp.pool.ntp.org iburst
server 1.jp.pool.ntp.org iburst

stratumweight 0

driftfile /var/lib/chrony/drift
rtcsync
makestep 10 3

allow 10.0.2.0/24 # すべてのコンピュータが所属するサブネット
bindcmdaddress 127.0.0.1
bindcmdaddress ::1

keyfile /etc/chrony.keys
commandkey 1
generatecommandkey

noclientlog
logchange 0.5
logdir /var/log/chrony
```

- 書式： server <NTPサーバ> [<オプション1> <オプション2> ...]
	- デフォルト： 指定なし
	- NTPクライアントとしてどのNTPサーバに時刻問い合わせに行くかを指定する。
	- オプションの中でiburstオプションは付けておく方がメリットのあるものである。chronydはiburstオプションの付いたNTPサーバに対して、起動直後に短い間隔で4回問い合わせをする（ntpdのiburstは8回）。



- 書式： rtcsync
	- デフォルト： 指定なし
	- chronyでは設定ファイルにrtcsyncと書いておけばシステムクロックを11分置きにハードウェアクロックに書き出してくれる。

- 書式： makestep <何秒以上> <何回目まで>
	- デフォルト： 指定なし
	- システムクロックの調整には、NTPサーバから取得した時刻にすぐに修正するstep調整と、他アプリへの影響が少ないようにシステムクロックのずれを徐々に修正するslew調整という2つの方式がある。
	- chronydは基本的にはslew調整を行うが、起動直後だけstep調整を行うようにすることができる。それがこのmakestepであり、続く1つ目の数字で何秒以上のずれがあればstep調整を行うか、2つ目の数字で起動から何回目の同期までstep調整を行うかを設定する。
	- 2つの数字両方の条件に一致している時はstep調整、そうでなければslew調整となる。
	- なお、chronydがslew調整中に強制的にstep調整させたい場合はchronyc -a makestepを実行する（ntpdateがインストールされているならntpdate <NTPサーバ>でも良いだろう）。

- 書式： maxslewrate <slewレート>
	- デフォルト： maxslewrate 83333.333
	- slew調整を最大どれだけの速さで行うかを決定する設定項目である。

- 書式： port <NTPリクエストの待ち受けポート番号>
	- デフォルト： port 123
	- chronydはntpdとは違い、設定によりNTPリクエストの待ち受けUDPポート番号を変更することができる。ただし、SELinuxが有効な場合はsemanage port -a -t ntp_port_t -p udp <ポート番号>を実行する必要がある（実行するにはpolicycoreutils-pythonをインストールすること）。
	- ここでport 0を指定するとNTPサーバとして待ち受けを行わず、NTPクライアントとしてだけ働くことになる。

allow / deny
書式：
- allow [all] <IPアドレスかサブネット>
- deny [all] <IPアドレスかサブネット>
	- デフォルト： 指定なし（全IPアドレスからのアクセスを禁止）
	- ntpdではrestrictで書いていた、NTPサーバとしてどのコンピュータにアクセスさせるか、の設定である。
	- allowに設定されたIPアドレスやサブネットはアクセスが許可され、denyに設定されたIPアドレスやサブネットはアクセスが許可されない。どちらも複数書くことができ、上にあるものが優先順位が高い。ただし、allを付けると上にあるものを上書きして指定されたIPアドレスやサブネットを許可/禁止する。

- 書式： bindaddress <IPアドレス>
	- デフォルト： 指定なし（*と::で待ち受け）
	- IPv4とIPv6で1つずつ指定可能
	- 特定のIPアドレスをバインドするための設定項目である。
- cmdport / cmdallow / cmddeny / bindcmdaddress
	- ntpdにおけるntpqやntpdcに当たる、chronydの状態閲覧や操作用のクライアントがchronycである。
	- cmd付きのこれらの設定項目では、chronycからの待ち受けもNTPリクエストの待ち受けと同様に設定することができる。
	- cmdportのデフォルト値は323である。こちらもUDP。SELinuxが有効な場合に変更するならsemanage port -a -t chronyd_port_t -p udp <ポート番号>を実行。

##### `ntpq -p`的なの

```
# 状態確認
chronyc sources
```


## memotitle
### 参考記事など
- https://www.sssg.org/blogs/naoya/archives/1144
