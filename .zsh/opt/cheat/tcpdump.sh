# テキスト表示
tcpdump -A port 80
# hex & text
tcpdump -X port 80
# interface 指定
tcpdump -i eth1 port 80
# ホストやポート番号をそのまま法事
tcpdump -nn port 80
# プロミスキャスモードにしない(自ホスト宛以外のデータはキャプチャしない)
tcpdump -p port 80

# キャプチャ結果をファイルに出力する
tcpdump -w a.cap port 80
# キャプチャ結果を読み込んで表示
tcpdump -r a.cap host 192.0.1.1
# キャプチャのバッファサイズを指定(-s)
tcpdump -w a.cap -s 65535 port 80

# ラインバッファを有効にする(-l)
tcpdump -nn -l -i eth0 port 53 | grep localhost

# 送信元ipアドレスを指定
tcpdump src host [src_ip]
# 送信先ipアドレスを指定
tcpdump dst host [dst_ip]
# 送信元もしくは送信先にipアドレスを指定
tcpdump host [target_ip]
# 送信元ipアドレスレンジを指定
tcpdump src net [src_net] mask [net_mask]
# 送信先ipアドレスレンジを指定
tcpdump dst net [dst_net] mask [net_mask]
# 送信元もしくは送信先にipアドレスレンジを指定
tcpdump host [target_net] mask [net_mask]
# 送信元のポート番号を指定
tcpdump src port [port_num]
# 送信先のポート番号を指定
tcpdump dst port [port_num]
# 送信先もしくは送信元のポート番号を指定
tcpdump port [port_num]
# and, or
tcpdump port 80 and host 192.168.0.100
