## 証明書作成

```
### 秘密鍵の作成
openssl genrsa 2048 > server.org
openssl genrsa -aes128 2048 > server.org

## パスワードをつけている場合は外す
openssl rsa -in server.org > server.key
# CSRの作成
openssl req -new -sha256 -key server.key > server.csr

# 署名(本来ならば認証局側で実施)
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key > server.crt
```

### 確認

```
## 証明書ファイルの内容を確認
openssl x509 -text -noout -in [file]

## 秘密鍵ファイルの内容を確認
openssl rsa -text -noout -in [file]

## CSRファイルの内容を確認
openssl req -text -noout -in [file]
```

### サーバー証明書と中間証明書等を結合(ELBなど。必要であれば)
- 認証の仕組み上、「サーバー証明書－＞中間証明書－＞（クロスルート証明書－＞）ルート証明書」の順番で格納

```
cat server.pem dvcacert.pem >> certificate.pem
```


### Apache 側の設定例

```
SSLCompression off
SSLProtocol All -SSLv2 -SSLv3
SSLCipherSuite AES128+EECDH:AES128+EDH
# SSLCipherSuite ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4

<VirtualHost xxx.com:443>
	DocumentRoot "/var/www/html"
	ServerName xxx.com

	SSLEngine on
	# 中間CA証明書
	SSLCertificateChainFile /etc/httpd/conf/ssl.crt/dvcacert.pem
	# 証明書
	SSLCertificateFile /etc/httpd/conf/ssl.crt/server.crt
	# サーバ証明書ファイル名
	SSLCertificateKeyFile /etc/httpd/conf/ssl.key/server.key
</VirtualHost>
```

## サーバー証明書チェーンの確認 (openssl s_client)

```
openssl s_client -connect www.example.com:443 -showcerts > www.example.com.crt
```

### 署名アルゴリズムの確認

```
openssl x509 -text -in server.crt | egrep '(Signature Algorithm|Subject|Issuer):'
openssl x509 -text -in intermediate.crt | egrep '(Signature Algorithm|Subject|Issuer):'
```


