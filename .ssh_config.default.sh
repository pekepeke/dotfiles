#!/bin/sh

FP=$HOME/.ssh/config
if [ -e $FP ] ; then
  echo $FP is already exists.
  exit 0
fi

cat <<EOM > $FP
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

#Host name
#  HostName xxx.xxx.xxx.xxx
#  Port 22
#  User hoge
#  IdentityFile ~/.ssh/id_rsa.hoge
#  ForwardX11Trusted no

# for proxy
#Host host1
#  HostName host1
#  User user1

#Host *.host
#  ProxyCommand ssh user@host1 -W %h:%p

#Host *.host
#  ProxyCommand ssh host1 nc -w 10 %h %p
#  ProxyCommand ssh host1 /path/to/connect %h %p
## wget http://www.meadowy.org/~gotoh/ssh/connect.c

#Host host2.host
#  HostName host2
#  User user2
EOM
