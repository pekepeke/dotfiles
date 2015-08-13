## basic usage

expect -c "
set timeout 5
spawn passwd
expect \"Enter passphrase:\"
send -- \"password\n\"
interact
"
### interact命令 = 「制御をユーザに返す」
### 対話型でない場合は expect eof exit 0 を使用する

expect -c "
spawn passwd a_user
expect Enter\ ;  send password; send \r
expect Retype\ ; send password; send \r;
expect eof exit 0
"

