# instll epel
yum install epel-release
# install REMI
# wget http://rpms.famillecollet.com/enterprise/remi-release-$(cat /etc/redhat-release | cut -d ' ' -f3 | cut -d '.' -f 1).rpm
# rpm -Uvh remi-release-$(cat /etc/redhat-release | cut -d ' ' -f3 | cut -d '.' -f 1).rpm

useradd www
passwd hogehoge
usermod -G wheel www

# vim /etc/inittab
----
id:3:initdefault:
----

# vim /etc/sysconfig/selinux
----
SELINUX=disabled
----

# cd /etc/cron.daily
mkdir disabled
mv /etc/cron.daily/rpm disabled
mv /etc/cron.daily/tmpwatch disabled
mv /etc/cron.daily/makewhatis.cron disabled
mv /etc/cron.daily/0anacron disabled

# vi /etc/ntp.conf
----
server ntp1.jst.mfeed.ad.jp
server ntp2.jst.mfeed.ad.jp
server ntp3.jst.mfeed.ad.jp
----

# vi /etc/sysconfig/i18n
----
LANG="ja_JP.UTF-8"
----

chkconfig cpuspeed --level 12345 off
chkconfig ip6tables off
chkconfig --level 1 lvm2-monitor off
chkconfig readahead_early off
chkconfig sendmail off

## visudo
----
wheel  ALL=(ALL)       ALL
----

yum -y remove cups           # cups：プリントサーバー
yum -y remove kudzu          # kudzu：ハードウェア構成変更検出
yum -y remove wireless-tools # wireless-tools,wpa_supplicant：無線LAN関係
yum -y remove wpa_supplicant
yum -y remove pcmciautils    # pcmciautils：ノートPC等のPCカードスロット用ドライバ
yum -y remove irda-utils     # irda-utils：赤外線通信用
yum -y remove ccid           # ccid：スマートカード用
yum -y remove gtk2           # gtk2：デスクトップ環境
yum -y remove bluez-gnome    # bluez-gnome,bluez-utils,bluez-libs：BlueTooth用
yum -y remove bluez-utils
yum -y remove blues-libs
yum -y remove alsa-lib       # alsa-lib：サウンド再生

# auto update
# yum -y yum-cron
# /etc/init.d/yum-cron start
# chkconfig yum-cron on
