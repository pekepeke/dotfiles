#!/bin/sh

FILE=$HOME/.ssh/config

[ ! -e ~/.ssh ] && mkdir ~/.ssh && chmod 700 ~/.ssh
[ ! -e ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa

if [ -e $FILE ] ; then
  echo "already exists: $FILE"
  exit 1
fi

cat <<EOM > $FILE
# ~/.ssh/config
# vim:sw=2 ts=2 expandtab fdm=expr foldexpr=getline(v\\:lnum)=~'^\\\\s*$'&&getline(v\\:lnum+1)=~'^Host\\\\s\\\\+\\\\S'?'<1'\\:1

Host *
  TCPKeepAlive yes
  ForwardAgent yes
  ServerAliveInterval 20
  ServerAliveCountMax 5
  Protocol 2
  GSSAPIAuthentication no
  ControlMaster auto
  ControlPath /tmp/%r@%h:%p
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

# Host localhost
#    User docker
#    StrictHostKeyChecking no
#    UserKnownHostsFile /dev/null
#    IdentityFile ~/.ssh/id_rsa_boot2docker_vm
#    HostName 127.0.0.1

# Host 192.168.1.*
#    StrictHostKeyChecking no
#    UserKnownHostsFile /dev/null

# Host 192.168.33.*
#    StrictHostKeyChecking no
#    UserKnownHostsFile /dev/null

#Host name
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

## socks proxy - http://blog.wktk.co.jp/ja/entry/2014/03/11/ssh-socks-proxy-mac-chrome
# ssh -f -N -D 1080 user@example.com
# Host fumidai.example.com
#   User user
#   Protocol 2
#   ForwardAgent yes
#   DynamicForward 1080

# Host gh-private
#     HostName github.com
#     IdentitiesOnly yes
#     IdentityFile ~/.ssh/github_key

# Host github
#     HostName github.com
#     IdentitiesOnly yes
#     IdentityFile ~/.ssh/work_github_key

EOM
