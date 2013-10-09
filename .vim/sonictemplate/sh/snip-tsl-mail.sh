#gmailのパラメータ設定
user="*****@******.jp"
pass="********"
to="********@******jp"
authorize="`perl -MMIME::Base64 -e 'print encode_base64("\000[Name]\@[domain]\000[pass]")'`"
subject="subject"

sleep 1
echo "EHLO `hostname`"
sleep 1
echo "AUTH PLAIN" ${authorize}
sleep 1
echo "MAIL FROM: <${user}>"
sleep 1
echo "rCPT TO: <${to}>"
sleep 1
echo "DATA"
sleep 1
(
cat <<EOF
From: ${user}
To: ${to}
Subject: $subject

hostname: `hostname`
.
EOM
) | perl -pe's/(?<!\r)\n/\r\n/'
sleep 1
echo "QUIT"
) | openssl s_client -connect smtp.gmail.com:465

