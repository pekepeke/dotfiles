#!/bin/bash

usage() {
  prg_name=`basename $0`
  cat <<EOM
  Usage: $prg_name [-h]
EOM
  exit 1
}

is_exec() {
	which $1 >/dev/null 2>&1
	return $?
}

get_command {
    if is_exec yum ; then
        echo yum install
    elif is_exec aptitude ; then
        echo aptitude install
    fi
}

is_redhat() {
	return $(is_exec yum)
}

is_debian() {
	return $(is_exec apt)
}

install_packages_deb() {
    inst_cmd="aptitude install"
}

install_packages_rhel() {
    inst_cmd="yum -y install"
    # init
    yum -y install yum-fastestmirror
    yum -y update
    $inst_cmd net-snmp net-snmp-devel libnet screen sysstat

    ## rpmforge
    wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.1-1.el5.rf.$(uname -i).rpm
    rpm -ivh rpmforge-release-0.5.1-1.el5.rf.$(uname -i).rpm
    sed -ie "s/enabled *= *1$/enabled = 0/g" /etc/yum.repos.d/rpmforge.repo

    # epel
    wget http://download.fedora.redhat.com/pub/epel/5/$(uname -i)/epel-release-5-4.noarch.rpm
    rpm -ivh epel-release-5-4.noarch.rpm
    sed -ie "s/enabled *= *1$/enabled = 0/g" /etc/yum.repos.d/epel.repo

    # livna
    wget http://rpm.livna.org/livna-release.rpm
    rpm -ivh livna-release.rpm
    sed -ie "s/enabled *= *1$/enabled = 0/g" /etc/yum.repos.d/livna.repo

    yum install git --enablerepo=rpmforge

    # mysql
    yum install lzo lzop --enablerepo=rpmforge
    yum install maatkit --enablerepo=epel
    mkdir /etc/maatkit/
    tee /etc/maatkit/maatkit.conf << EOF
defaults-file=/etc/my.cnf
EOF
    tee ~/.maatkit.conf <<EOF
u=god
p=god
EOF
    chmod 640 /etc/maatkit/maatkit.conf
    chmod 600 ~/.maatkit.conf
    tee ~/.my.cnf <<EOF
[client]
password       = god
user           = god
port            = 53300
socket          = /tmp/mysql.sock
[mysql]
no-auto-rehash
EOF

    wget http://mysqltuner.com/mysqltuner.pl
    chmod +x mysqltuner.pl
    mv mysqltuner.pl /usr/local/bin/mysqltuner
    yum install innotop --enablerepo=epel

    wget http://hackmysql.com/scripts/mysqlidxchk-1.1
    chmod +x mysqlidxchk-1.1 && mv mysqlidxchk-1.1 /usr/local/bin/
    ln -s /usr/local/bin/mysqlidxchk-1.1 /usr/local/bin/mysqlidxchk

    wget http://hackmysql.com/scripts/mysqlreport
    chmod +x mysqlreport && mv mysqlreport /usr/local/bin

    wget http://hackmysql.com/scripts/mysqlsla
    chmod +x mysqlsla-2.03 && mv mysqlsla-2.03 /usr/local/bin/mysqlsla
}

main() {
	if [ ! -e ~/.vimrc ]; then
		if [ -e /etc/skel/.bashrc ]; then
			echo alias rm='rm -i' >> /etc/skel/.bashrc
			echo alias mv='mv -i' >> /etc/skel/.bashrc
			echo alias cp='cp -i' >> /etc/skel/.bashrc
			echo umask 002 >> /etc/skel/.bashrc
		fi
		tee ~/.vimrc <<EOF
syntax on
set ts=4
set expandtab
set termencoding=utf-8
set encoding=japan
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
set fenc=utf-8
set enc=utf-8
set ignorecase
set incsearch
set smartcase
set scrolloff=3
EOF
		tee ~/.screenrc <<EOF
defencoding utf8
escape ^z^z
bind s
hardstatus alwayslastline "%\`%-w%{=b bw}%n %t%{-}%+w"
EOF
	fi
}

OPTIND_OLD=$OPTIND
OPTIND=1
while getopts "hv" opt; do
  case $opt in
    h)
      usage ;;
    v) ;;
  esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD
if [ $OPT_ERROR ]; then
  usage
fi

main "$@"

# vim: set fdm=marker sw=2 ts=2 ft=sh et:
