/usr/bin/newaliases
for i in access canonical relocated transport virtual
do
if [ -f /etc/postfix/$i ] ; then
    /usr/sbin/postmap hash:/etc/postfix/$i < /etc/postfix/$i
fi
done
/usr/sbin/postfix start
