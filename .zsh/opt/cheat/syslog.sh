# /var/log/message
dmesg -n 1 # EMERG
dmesg -n 8 # DEBUG

# crush dump
/var/log/dump
/var/crash

# files
auth             セキュリティ・認証関連
authpriv         セキュリティ・認証関連 （プライベート）
cron             cron 関連メッセージ
daemon           デーモン（サーバプログラム）関連
kern             カーネル関連
lpr              プリンタ関連
mail             メール関連。メールサーバ（sendmail）などが利用
news             NetNews 関連のメッセージ
security         auth に同じ （Linux、FreeBSDのみ）
ftp              ftp 関連（FreeBSDのみ）
ntp              ntp 関連（FreeBSDのみ）
syslog           syslog 自身のメッセージ
user             ユーザーアプリケーションのメッセージ
uucp             UUCP 関連のメッセージ
local0～local7   独自に利用できる facility

# login
lastlog    Ｕｎｉｘの全ユーザーの最終ログインを見る
last       ログイン履歴を新しいモノから順に見る。
w          ログインしている（tty使用中)のユーザー一覧
who        ログインしている（tty使用中)のユーザー一覧
finger     who/wと殆ど同じ
ps         起動中のプロセスを見る
