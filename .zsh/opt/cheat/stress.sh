# cpu
yes >> /dev/null
openssl speed -multi `grep processor /proc/cpuinfo|wc -l`
# memory
/dev/null < $(yes)
perl -e 'while(1){$i++;$h{$i}=$i}'
# load average
for i in {0..9}; do nohup `while :; do echo 1 > /dev/null; done;` & done

 # rpm -hiv http://packages.sw.be/stress/stress-1.0.2-1.el5.rf.x86_64.rpm
stress --cpu 1 --io 4 --vm 4 --vm-bytes 256M --timeout 500s
stress --verbose --cpu 1 --io 1 --vm 1 --hdd 1 --timeout 10

