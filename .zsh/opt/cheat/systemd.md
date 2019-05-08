## TIPS
### service 一覧

```
systemctl list-unit-files --type=service
systemctl list-unit-files --type=service | grep -P 'nginx|postfix'
```

### 設定の上書き
-  /etc/systemd/system/ 配下に記載
	- オリジナルは /lib/systemd/system/ 配下

## 基本コマンド
### systemctl list-units
一覧表示

### systemctl list-unit-files
インストールされているUnitファイルの一覧表示

### systemctl daemon-reload
サービス再読込

### systemctl enable httpd
Unit の有効化

### systemctl disable httpd
Unit の無効化

### systemctl is-enabled httpd
有効・無効の確認

### systemctl reenable httpd
Unit の再有効化

### systemctl start httpd
Unit の起動

### systemctl status httpd
Unit の起動状態確認

### systemctl show httpd
Unit の詳細確認

### systemctl stop httpd
Unit の停止

### systemctl reload httpd
Unit の設定ファイル再読み込み

### systemctl restart httpd
Unit の再起動

### systemctl try-restart httpd
Unit の再起動試行

### systemctl reload-or-restart httpd
Unit の再読み込みまたは再起動

### systemctl reload-or-try-restart httpd
Unit の再読み込みまたは再起動試行

### systemctl kill httpd
Unit の強制起動

### systemctl mask httpd / systemctl unmask httpd
Unit のマスキング(mask することでサービスの起動自体ができなくなる)

### systemctl is-active httpd
Unit の起動状態の確認

### systemctl is-failed httpd
Unit の異常状態の確認

### systemctl reset-failed httpd
Unit の異常状態のリセット

### systemctl list-dependencies httpd
Unit の依存関係の確認

## 書き方
```
[Unit]
Description=Load dump capture kernel
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/opt/bin/run-kexec.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

### @see
- man 5 systemd.unit
- man 5 systemd.service

### Unit セクション
#### Description
説明を書く

#### After/Before
- 指定したユニットの実行順番の依存関係を指定する

#### Requires/Wants
ユニットの依存関係の定義

### Service セクション
#### Type
デフォルト値は simple
- simple
- forking
- oneshot
	- コマンドとしてすぐに終わるような場合に使う
- notify
- dbus

#### ExecStart
実行するコマンドラインを記述する

#### RemainAfterExit
Typeがoneshot の場合はコマンドの実行終了後もステータスをアクティブにする必要があるため、RemainAfterExit=yes を指定する。

### Installセクション
#### WantedBy/RequiredBy
ユニットを enable したときに、.wants, .requires にシンボリックリンクを作る

```bash
ls -la /etc/systemd/system/multi-user.target.wants/
```

### Examples

#### kdump
```
kernname=`uname -r`
boot_dir=/boot
vmlinuz="$boot_dir/vmlinuz-$kernname"
initramfs="$boot_dir/initramfs-$kernname.img"
root_dev=`cat /proc/cmdline  | sed 's/ /\n/g' | grep ^root= | cut -f2- -d'='`

echo /usr/bin/kexec -p "$vmlinuz" --initrd="$initramfs" --append="root=$root_dev single irqpoll maxcpus=1 reset_devices"
/usr/bin/kexec -p "$vmlinuz" --initrd="$initramfs" --append="root=$root_dev single irqpoll maxcpus=1 reset_devices"
echo "kexec comman executed"

exit 0
```

#### sshd
```
[Service]
ExecStart=/usr/bin/sshd -D
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always
```
