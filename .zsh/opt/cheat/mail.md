## mime
### perl

```
# iso-2022-jp
echo テスト |perl -MEncode -pe '$_ = encode("MIME-Header-ISO_2022_JP",  decode("UTF-8", $_))'
# utf-8
echo テスト |perl -MEncode -pe '$_ = encode("MIME-Header",  "UTF-8")'
```

### nkf

```
nkf -w: UTF-8 に変換
nkf -e: EUC-JP に変換
nkf -s: Shift-JIS に変換
nkf -j: JIS(ISO-2022-JP) に変換

# mime encoding
echo ほげほげ | nkf -M
# mime+Base64
echo ほげほげ | nkf -MB
# mime + quoted-printable
echo ほげほげ | nkf -MQ
# decode
echo "=?ISO-2022-JP?B?GyRCJFskMiRbJDIbKEI=?=" | nkf -w
echo GyRCJFskMiRbJDIbKEI= | nkf -wmB
echo "=1B=24B=24=5B=242=24=5B=242=1B=28B" | nkf -wmQ
```
## 実際の文字列
### Subject
- ISO-2022-JP + quoted-printable

```
Subject: =?ISO-2022-JP?Q?iTunes_Movie_=1B$B%K%e!<%j%j!<%9$HCmL\:nIJ=1B(B?=
```

- ISO-2022-JP + base64

```
Subject: =?ISO-2022-JP?B?GyRCJUElMSVDJUg5WEZ+JE4bKEI=?=
 =?ISO-2022-JP?B?GyRCJCpDTiRpJDshSiVmJUolJCVGJUMlSSEmJTclTSVeGyhCIA==?=
 =?ISO-2022-JP?B?GyRCJTAlayE8JVchSxsoQg==?=
```

- utf-8 + quoted-printable

```
Subject: =?utf-8?Q?Distributed=20TensorFlow=E3=81=AE=E8=A9=B1?=
```

- utf-8 + base64
```
Subject: =?UTF-8?B?44CQ44OX44Op44Kk44Og5Lya5ZOh44Gu5pa5?=
 =?UTF-8?B?44G444GK55+l44KJ44Gb44CRUHJp?=
 =?UTF-8?B?bWUgTm93IOOCqOODquOCouaLoeWkpyjmnbHkuqzjg7vljYPokYkp?=
```

### 本文
- content-type の charset, content-transfer-encoding を参照する


### nkf
- encoding = base64, charset=utf8
	-  | nkf -mB
- encoding = base64, charset=utf8
	-  | nkf -mQ
- encoding = 7bit, charset=iso2022jp
	-  | nkf -mB
- encoding = base64, charset=iso2022jp
	-  | nkf -mB
- encoding = 8bit, charset=shift_jis
	- ?
- subject や mailto 部分→大体は自動判別してくれる
	- | nkf -m

## send
### mail

```
echo "hello" | sendmail to@example.com

cat <<__EOM__ | sendmail to@example.com
From: from@example.com
To: to@example.com
Subject: =?ISO-2022-JP?B?GyRCJUYlOSVIGyhC?=
Content-Type: text/plain; charset=ISO-2022-JP
MIME-Version: 1.0

TEST MAIL
__EOM__

echo "hello" | mail to@example.com
echo "本文" | mail -s "タイトル" -r from@example.com -c cc1@example.com -c cc2@example.com to1@example.com to2@example.com
mail -a [attachmemnt] -A [account] to@example.com
# 通信ログの詳細を確認
mail -v smoke
```

### send mail through smtp

```
echo test | mail -s "test" -S "smtp=smtp://mail.example.com:25" hoge@example.com


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
