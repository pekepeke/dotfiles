expect -c "               # expect コマンドを実行
set timeout 20
spawn telnet $HOST
expect \"login: \" ; send -- \"$USER\r\"
expect \"password:\ \" ; send -- \"$PW\r\"
expect \"$ \" ; send -- \"ls\r\"
expect \"$ \" ; send -- \"exit\r\"
send -- \"\r\"
expect eof
"
