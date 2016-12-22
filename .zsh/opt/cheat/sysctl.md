sysctl
======

## 設定ファイル
- `/etc/sysctl.conf`
	- sysctl -p で設定を反映させる
	- sysctl [param] で反映確認

## 一時的に変更する方法(再起動で戻る)

```
echo 5 > /proc/sys/kernel/panic
sysctl -w kernel.panic=5
sysctl kernel.panic
```

## sysctl option
- `-n`
	- キーの名前は表示せず、値だけ表示する
- `-e`
	- 不明なキーについてエラーを無視する
- `-N`
	- 名前のみ表示する
- `-q`
	- 値のセットを標準出力に表示しない
- `-w`
	- sysctl の設定を変更する場合には、このオプションを指定する
- `-p`
	- 指定されたファイルから読み込んだ内容を sysctl 設定へロード。指定がなければ `/etc/sysctl.conf`から
- `-a`
	- 現在利用できる全ての値を表示
- `-A`
	- -a に同じ

## 各種パラメーター

### 全般
- `kernel.panic = 0`
	- 何秒後に再起動を行うか

### cache
- `vm.drop_caches`
	- 1: ページキャッシュクリア
	- 2: dentry と inode のクリア
	- 3: 1 + 2

```
sync
sysctl -w vm.drop_caches=1
echo 2 > /proc/sys/vm/drop_caches
```

### ディスク
- fstab
	- noatime を更新させない
		- `LABEL=/ / ext4 defaults,noatime 1 1`
- I/O スケジューラ変更
	- `echo deadline > /sys/block/hda/queue/scheduler`
		- noop スケジューラ
			- FIFO で処理する
		- deadline スケジューラ
			- リアルタイム向け
			- 各リクエストに待ち時間が与えられ、リクエストの期限が来る前にリクエストの対応が行われない場合、そのリクエストがキューの先頭に置かれ、ディスクの近くの位置に対するリクエストとマージされて即座に対応が行われmる。
		- anticipatory スケジューラ
			- I/O 実行後にディレイを強制的に入れ、次のI/Oを強制的にブロックする
		- cfq スケジューラ
			- リクエストはキューに入れられ、シーク時間が最小限になるよう並べられ対応が行われる方式
	- 再起動時にも適用されるように `/etc/rc.d/rc.local` あたりに追加しておく

### プロセス・ファイル
- `kernel.threads-max = 8190`
	- システム全体のプロセス数の上限
- `fs.file-max = 99002`
	- ファイルディスクリプタの最大数を指定する。Webサーバなど、外部からのアクセスが多い場合には多く設定しておかないとアクセス遅延などの問題が発生する。
	- ユーザー単位のディスクリプタに関しては `/etc/security/limits.conf` で設定する
- `vm.swapniness = 0`
	- スワップさせない設定

### ネットワーク
- `net.ipv4.tcp_tw_reuse=1`
	- TCPの`TIME_WAIT`を再利用する。`TIME_WAIT`はソケットオープン状態であるため、多数残存するとパフォーマンスに大きな影響がでる。
- `net.ipv4.tcp_tw_recycle = 1`
	- TCPの`TIME_WAIT`の再利用を高速化する
- `net.ipv4.tcp_fin_timeout = 30`
	- TCPの`FIN`を送信してからのタイムアウト時間
- `net.ipv4.ip_local_port_range = 32768 61000`
	- サーバ内部で使用するポート番号の範囲。リバースプロキシなどで使用している場合には、1024から65535とする。
- `net.ipv4.tcp_window_scaling`
	- RFC 1323のTCPウィンドウスケーリングを有効にします．この機能を用いると，（接続先が対応していれば） TCP接続で64 KByte以上のウィンドウが使えるようになります．送受信バッファサイズを64 KByte以上に設定した場合は， そのバッファを有効に利用できるようにこのオプションを有効にしておきます．
- `net.ipv4.tcp_rmem`
	- TCPが受信バッファサイズを調整するために用いられます．このsysctl変数は，[min,default,max]の3つの値を持ちます． それぞれの値の意味は，下記の通りです．
		- min ..... 各TCPソケットが用いる受信バッファの最小値です．この値は，`SO_RCVBUF`を用いてソケットの 最低受信バッファサイズを宣言する際には用いられません．
		- default ..... TCPソケットの受信バッファのデフォルト値です． この値は，`net.core.rmem_default`よりも優先されます．
		- max ..... 各TCPソケットが用いる受信バッファの最大値です．この値よりも`net.core.rmem_max`が優先されます． この値は，`SO_RCVBUF`を用いてソケットの受信バッファサイズを制限する際には用いられません．
- `net.ipv4.tcp_wmem`
	- TCPが送信バッファサイズを調整するために用いられます．このsysctl変数も[min,default,max]の3つの値を持ちます． それぞれの値の意味は，`net.ipv4.tcp_rmem`と同様です．
- net.ipv4.tcp_mem
	- TCPがメモリ使用量を追跡するために用いられます．このsysctlは，[low,pressure,high]の3つの値を持ちます． それぞれの値の意味は，下記の通りです．
		- low ..... TCPは，グローバルに割り当てたメモリがこの数値以下の場合は， メモリアロケーションを調整しません．
		- pressure ..... TCPがアロケートしたメモリがこの数値を越えると， TCPはメモリ消費を抑えるようになります．
		- high ..... TCPがグローバルに割り当てるメモリの最大値です．
	- net.ipv4.tcp_rmemやnet.ipv4.tcp_wmemで送受信バッファサイズを大きくした場合は， この値も大きくしておく必要があります．
- `net.core.rmem_default`
	- net.ipv4.tcp_rmemのdefaultと同様です．ただし，設定値は，net.ipv4.tcp_rmemのdefaultの方が優先されます．
- `net.core.wmem_default`
	- net.ipv4.tcp_wmemのdefaultと同様です．ただし，設定値は，net.ipv4.tcp_wmemのdefaultの方が優先されます．
- `net.core.rmem_max`
	- net.ipv4.tcp_rmemのmaxと同様です．ただし，設定値はこちらの方が優先されます．
- `net.core.wmem_max`
	- net.ipv4.tcp_wmemのmaxと同様です．ただし，設定値はこちらの方が優先されます．
- `net.core.optmem_max`
	- 補助バッファの最大サイズを表します．
- `net.core.rmem_max_backlog = 4096`
	- プロセッサが一度に処理するパケット量
- `net.ipv4.tcp_max_tw_buckets = 131072`
	- tcp の `TIME_WAIT` を保持できる上限

