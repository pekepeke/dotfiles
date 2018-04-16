#!/bin/sh

FILE=$HOME/.ssh/config

[ ! -e ~/.ssh ] && mkdir ~/.ssh && chmod 700 ~/.ssh
[ ! -e ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -b 4096
[ ! -d ~/.ssh/certs ] && mkdir -p ~/.ssh/certs

if [ -e $FILE ] ; then
  [ "$1" != "-s" ] && echo "already exists: $FILE" 1>&2
  exit 1
fi

cat <<'EOM' > $FILE
# ~/.ssh/config
# vim:sw=2 ts=2 expandtab fdm=expr foldexpr=getline(v\\:lnum)=~'^\\\\s*$'&&getline(v\\:lnum+1)=~'^Host\\\\s\\\\+\\\\S'?'<1'\\:1

Host *
  TCPKeepAlive yes
  ForwardAgent yes
  ServerAliveInterval 20
  ServerAliveCountMax 5
  Protocol 2
  GSSAPIAuthentication no
  # cannot use on cygwin
  ControlMaster auto
  ControlPath /tmp/ssh-%r@%h:%p.socket
  # ControlPath ~/.ssh/master-%r@%h:%p.socket
  # ControlPath /tmp/%C
  # ControlPersist yes
  # ControlPersist 10m
  # RemoteForward 52698 127.0.0.1:52698 # for remote edit(subl, mate2)

Host github.com
  User git
  HostName github.com
  TCPKeepAlive yes
  IdentitiesOnly yes


# Host xxx.github.com
#   User git
#   HostName github.com
#   TCPKeepAlive yes
#   IdentitiesOnly yes
#   IdentityFile ~/.ssh/certs/hoge_id_rsa

Host *-ec2-
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    # LogLevel QUIET # warning がうざいときに

# Host localhost
#    User docker
#    StrictHostKeyChecking no
#    UserKnownHostsFile /dev/null
#    IdentityFile ~/.ssh/id_rsa_boot2docker_vm
#    HostName 127.0.0.1
#    LogLevel QUIET

# Host 192.168.1.*
#    StrictHostKeyChecking no
#    UserKnownHostsFile /dev/null
#    LogLevel QUIET

# Host 192.168.33.*
#    StrictHostKeyChecking no
#    UserKnownHostsFile /dev/null
#    LogLevel QUIET

# Host name
#  HostName xxx.xxx.xxx.xxx
#  Port 22
#  User hoge
#  IdentityFile ~/.ssh/id_rsa.hoge
#  ForwardX11Trusted no

# for database server proxy
# Host dbproxyhost
#   HostName        apphost
#   User            user1
#   LocalForward 13306 dbhost:3306

# for proxy
# Host host1
#   HostName host1
#   User user1

# Host *.host
#   ProxyCommand ssh user@host1 -W %h:%p

# Host *.host
#   ProxyCommand ssh host1 nc -w 10 %h %p
#   ProxyCommand ssh host1 /path/to/connect %h %p
# # wget http://www.meadowy.org/~gotoh/ssh/connect.c

# Host host2.host
#   HostName host2
#   User user2
#   ProxyCommand connect-proxy -H proxy_host:3128 %h %p
#   ProxyCommand nc -X connect -x proxy_host:3128 %h %p
#   ProxyCommand socat - PROXY:proxy_host:%h:%p,proxyport=3128
#   ProxyCommand socat - PROXY:proxy_host:%h:%p,proxyport=3128,proxyauth=user:pass

## socks proxy - http://blog.wktk.co.jp/ja/entry/2014/03/11/ssh-socks-proxy-mac-chrome
# ssh -f -N -D 1080 user@example.com
# Host fumidai.example.com
#   User user
#   Protocol 2
#   ForwardAgent yes
#   DynamicForward 1080

# ssh -N -f -D 10080 user@example.com
# Host example tunnel
#   HostName example.com
#   User user
# Host tunnel
#   DynamicForward 10080

# Host gh-private
#     HostName github.com
#     IdentitiesOnly yes
#     IdentityFile ~/.ssh/github_key

# Host github
#     HostName github.com
#     IdentitiesOnly yes
#     IdentityFile ~/.ssh/work_github_key

# http://qiita.com/kawaz/items/a0151d3aa2b6f9c4b3b8
# Host */*
#   ProxyCommand ssh -W "$(basename "%h")":%p "$(dirname "%h")"
# Host *+*
#   ProxyCommand ssh -W "$(sed -E 's/.*\+//'<<<"%h")":%p "$(sed -E 's/\+[^\+]*//'<<<"%h")"
Host */*
  ProxyCommand ssh -W "$(H="%h"; echo ${H##*/})":%p "$(H="%h"; echo ${H%%%%/*})"
Host *+*
  ProxyCommand ssh -W "$(H="%h"; echo ${H##*+})":%p "$(H=%h; echo ${H%%%%+*})"

EOM
