### send mail

```
echo "hello" | sendmail to@example.com
echo "hello" | mail to@example.com
echo "本文" | mail -s "タイトル" -r from@example.com -c cc1@example.com -c cc2@example.com to1@example.com to2@example.com
mail -a [attachmemnt] -A [account] to@example.com
# 通信ログの詳細を確認
mail -v smoke
```

### send mail through smtp

```
cat ~/.mailrc <<EOM
set smtp=smtp://192.168.0.1:25
account hoge {
  set from="hoge@example.com"
}
account fuga {
  set from="fuga@example.com"
}
alias smoke to1@example.com to2@example.com
EOM
```

### sendmail with telnet

```
telnet localhost 25
HELO example.com
MAIL FROM: user@example.com
RCPT TO: to@example.com
DATA
From: user@example.com
Subject: test
Hello world.
.
QUIT
```
