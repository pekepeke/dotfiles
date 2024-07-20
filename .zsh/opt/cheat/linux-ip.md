## ip

```sh
ifconfig eth0 down
ifdown eth0
ifconfig eth0 up
ifup eth0

ip l set eth0 up
ip l set eth0 down
nmcli c down eth0
nmcli c up eth0

```

net-tools は今でも使えるが、一応 deprecated 予定なので、できるだけ新しいコマンドを使用したほうがよさそう。

| net-tools  | iproute2               |
| ---------- | ---------------------- |
| ifconfig   | ip a(addr), ip l(link) |
| route      | ip r(route)            |
| netstat    | ss                     |
| netstat -i | ip -s l(link)          |
| arp        | ip n(neighbor)         |

## コマンドの使用例
```sh
# IPアドレスを設定
nmcli c add type eth ifname eth1 con-name eth1
nmcli c mod eth1 ipv4.method manual ipv4.addresses "192.168.122.69/24 192.168.122.1"
nmcli c down eth1
nmcli c up eth1
# 特殊デバイスの状態確認
ip a show dev eth0

# デバイスのup/down
ifconfig eth1 up
ifconfig eth1 down
ip l set eth1 up
ip l set eth1 down
nmcli c down eth1
nmcli c up eth1

# ルーティングテーブルの確認
ip r

# デフォルトゲートウェイの追加、削除
ip route add default via 192.168.122.1
ip route del default via 192.168.122.1

# デバイスごとのパケット処理数
ip -s 1

# TCPソケットの状態確認
ss -nat
# UDPソケットの状態確認
ss -nau

# ARPテーブルの確認
ip n

# ARPテーブルの無効化
ip n flush 192.168.122.71 dev eth0
ip n del 192.168.122.71 dev eth0
```

