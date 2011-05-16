#!/bin/sh

FP=$HOME/.ssh/config
if [ -e $FP ] ; then
  echo $FP is already exists.
  exit 0
fi

cat <<EOM > $FP
# ~/.ssh/config
# vim:sw=2 ts=2 expandtab fdm=expr foldexpr=getline(v\\:lnum)=~'^\\\\s*$'&&getline(v\\:lnum+1)=~'^Host\\\\s\\\\+\\\\S'?'<1'\\:1
TCPKeepAlive yes
ServerAliveInterval 20
SerAliveCountMax 5
Protocol 2

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

#Host host2
#  HostName host2
#  User user2
#  ProxyCommand ssh host1 nc %h %p
EOM
