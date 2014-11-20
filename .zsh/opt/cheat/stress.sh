# cpu
yes >> /dev/null
openssl speed -multi `grep processor /proc/cpuinfo|wc -l`
# memory
/dev/null < $(yes)
perl -e 'while(1){$i++;$h{$i}=$i}'
# load average
for i in {0..9}; do nohup `while :; do echo 1 > /dev/null; done;` & done


