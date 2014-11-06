# eth0の通信を全て100ms遅延
sudo tc qdisc add dev eth0 root netem delay 100ms
# 戻し
sudo tc qdisc del dev eth0 root

