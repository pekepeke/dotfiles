#!/bin/bash

sudo apt-get update
# sudo apt-get install linux-image-generic-lts-raring linux-headers-generic-lts-raring
sudo apt-get install linux-image-extra-`uname -r` linux-image-extra-virtual
cat <<'EOM'
#
# Due to a bug in LXC, docker works best on the 3.8 kernel. Precise comes with a 3.2 kernel, so we need to upgrade it. The kernel you’ll install when following these steps comes with AUFS built in. We also include the generic headers to enable packages that depend on them, like ZFS and the VirtualBox guest additions. If you didn’t install the headers for your “precise” kernel, then you can skip these headers for the “raring” kernel. But it is safer to include them if you’re not sure.
#

# reboot
sudo reboot

#
# continue to install, press Enter key
#
EOM
read
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common

# Add the Docker repository key to your local keychain
# using apt-key finger you can check the fingerprint matches 36A1 D786 9245 C895 0F96 6E92 D857 6A8B A88D 21E9
# sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"

# Add the Docker repository to your apt sources list.
# sudo sh -c "echo deb http://get.docker.io/ubuntu docker main\
# > /etc/apt/sources.list.d/docker.list"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# TODO : ARCH
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

# Update your sources
sudo apt-get update

# Install, you will see another warning that the package cannot be authenticated. Confirm install.
# sudo apt-get install lxc-docker
sudo apt-get install docker-ce

echo "## updating ufw setting"
sudo ufw allow 4243/tcp

