#!/bin/bash

sudo docker pull crosbymichael/dockerui

ip_addr=$(/sbin/ip -o route get 255.255.255.255 | grep -Eo 'src\s+\S+' | awk '{print $2}')
cat <<EOM
#
# change upstart config(/etc/init/dockerd.conf)
# add commandline -H -api-enable-cors
#


description "Docker daemon"
start on filesystem or runlevel [2345]
stop on runlevel [!2345]
respawn
exec `which docker` -d -H="unix://var/run/docker.sock" -H="tcp://${ip_addr}:4243" -api-enable-cors

#
# restart dockerd
#
sudo stop dockerd
sudo start dockerd

#
# launch dockerd
#
sudo docker run -d crosbymichael/dockerui /dockerui -e="http://${ip_addr}:4243" 68de52ae510f
sudo docker port 68de52ae510f 9000
EOM
