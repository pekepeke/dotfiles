sar        システム全体の稼働状況を確認する
vmstat     システム全体の稼働状況を確認する
mpstat     CPU使用稼働状況を確認する
iostat     ハードディスク、CPUの使用状況を確認する
ifstat     ネットワーク周りの使用状況を確認する
ps         プロセス情報を確認する
swapstat   swap 状態を確認する
prtstat    process 状態を確認する
dstat      リソース監視ツール

dstat -ta --top-cpu                  # CPU
dstat -ta --top-io-adv --top-bio-adv # IO
dstat -af                            # 全部見る
dstat --output dstat.csv             # csv出力
