cp /etc/hosts /etc/hosts.org
cp /etc/hosts /etc/hosts.new
sed -i -e 's!^::1!# \0!' /etc/hosts.new
cp -f /etc/hosts.new /etc/hosts
