Apache
=======

## Tips

### 各種設定確認

```
httpd -t -D DUMP_CONFIG 2>/dev/null | grep '# In' | awk '{print $4}' # 設定ファイル一覧
httpd -t -D DUMP_CONFIG 2>/dev/null | grep -v '#'                    # 設定ファイル内容
httpd -V                 # コンパイル時の設定
httpd -S -D SSL          # 実行時の設定
httpd -S
httpd -t -D DUMP_VHOSTS
httpd -l                 # 静的モジュール一覧
httpd -M                 # ロード済みモジュール一覧
rpm -qi httpd            # パッケージ情報
rpm -q --changelog httpd # パッケージ更新履歴

```


### ログのパース

```
### combined
| perl -ne 'print join("\t",  /^(.*?) (.*?) (.*?) \[(.*?)\] "(.*?)" (.*?) (.*?) "(.*?)" "(.*?)"/),  "\n"' | awk -F'\t' '{print $6}'
| perl -ne 'print join("\t",  /^(.*?) (.*?) (.*?) \[(.*?)\] "(.*?)" (.*?) (.*?) "(.*?)" "(.*?)"/),  "\n"' | awk -F'\t' '{sum[$6]+=1}; END { for (key in sum) { print key,  sum[key] }}'
| perl -ne 'print join("\t",  /^(.*?) (.*?) (.*?) \[(.*?)\] "(.*?)" (.*?) (.*?) "(.*?)" "(.*?)"/),  "\n"' | awk -F'\t' '{print $9}'
### common でも利用可能
| perl -pe 's/ (?:\[(.*?)\]|"(.*?)"|(\S*))/\t$1$2$3/g' | awk -F'\t' '{print $9}'

5 = uri
6 = status code
8 = referer
9 = ua

### ltsv
| perl -F'\t' -nale '%h=map{split/:/, $_, 2}@F;print"$h{time}\t$h{ua}"'
```

## 設定関連

### Require ディレクティブ(>= 2.4)

```
## ip addr
Require ip 127.0.0.1

## method
Require method GET POST

## local address
Require local

## UA
<Location /admin>
  SetEnvIf User-Agent ^IamAdmin/0¥.1 admin_ok
  Require env admin_ok
</Location>
<Location /admin>
  Require expr "${USER_AGENT} ^IamAdmin/0¥.1"
</Location>

## 特定の時間帯
<Location /goldentime_only>
  Require expr "%{TIME_HOUR} -ge 18 && %{TIME_HOUR} -le 23"
</Location>

## 192.168.1 AND group=admin ならば許可
<Location /admin>
  <RequireAll>
    Require ip 192.168.1
    Require group admin
  </RequireAll>
</Location>

## 192.168.1 OR group=admin なら許可
<Location /admin>
  <RequireAny>
    Require ip 192.168.1
    Require group admin
  </RequireAny>
</Location>

## アクセス元のuserがsuperadminだったら無条件で許可、または、IPアドレスが192.168配下で、かつ、adminグループであるか192.168.1以下のIPアドレスっだたら許可。ただし、上記が問題なくても、groupがblacklistに所属している場合はNG
<Location /admin>
  <RequireAll>
    <RequireAny>
      # userがsuperadminだったら無条件で許可
      Require user superadmin

      # または、IPアドレスが192.168以下で、かつ、adminグループであるか
      # 192.168.1以下のIPアドレスっだたら許可
      <RequireAll>
        Require ip 192.168
        <RequireAny>
            Require group admin
            Require ip 192.168.1
        </RequireAny>
      </RequireAll>
    </RequireAny>

    # ただし、上記の中でgroupがblacklistに所属している場合はNG
    <RequireNone>
      Require group blacklist
    </RequireNone>
  </RequireAll>
</Location>

```

### リバースプロキシ

```
# SSLProxyEngine on
ProxyPass / http://localhost:8080/
ProxyPassReverse / http://localhost:8080/
ProxyPassReverseCookieDomain fuga.com localhost
ProxyPassReverseCookiePath / /
# mod_rpaf
<IfModule mod_rpaf-2.0.c>
    RPAFenable On
    RPAFsethostname On
    RPAFproxy_ips 127.0.0.1 10. 172.16.
    RPAFheader X-Forwarded-For
</IfModule>
# mod_remoteip (>= 2.4)
LoadModule remoteip_module modules/mod_remoteip.so
<IfModule remoteip_module>
    RemoteIPHeader x-forwarded-for
    RemoteIPProxiesHeader Remote_Addr
    RemoteIPTrustedProxy 10.1.0.0/24
</IfModule>

<Location "/proxy">
    ProxyPass http://www.example2.com
    ProxyPassReverse http://www.example2.com
    ProxyPassReverseCookieDomain www.example2.com www.example1.com
    ProxyPassReverseCookiePath / /proxy/
    AuthType Basic
    AuthName "Only for administrators"
    AuthUserFile /usr/local/apache/passwd/passwords
    Require user admin
</Location>

<VirtualHost *:443>
    # ssl 設定を記述...
    RequestHeader set X_FORWARDED_PROTO 'https'
    ProxyPass /rails http://localhost:3000/rails
    ProxyPassReverse /rails http://localhost:3000/rails
</VirtualHost>

# ssl にリバースプロキシ
<VirtualHost *:80>

  RewriteEngine on
  SSLProxyEngine on

  ProxyPass / https://localhost/
  ProxyPassReverse / https://localhost/
  ProxyPassReverseCookieDomain fuga.com localhost
  ProxyPassReverseCookiePath / /
</VirtualHost>

<VirtualHost *:80>

  RewriteEngine on
  SSLProxyEngine on

  RewriteCond %{HTTP_USER_AGENT} hogemoge
  RewriteRule ^(.*)$ https://hoge.example.com$1 [P]
</VirtualHost>
```

### `mod_expires`/`deflate_module`/`mod_deflate`
`mod_deflate` => deprecated なモジュール

```
<IfModule mod_expires.c>
    ExpiresActive On
    # ExpiresDefault "access plus 1 seconds"
    ExpiresByType image/x-icon "access plus 3 days"
    ExpiresByType image/vnd.microsoft.icon "access plus 3 days"
    ExpiresByType image/jpeg "access plus 3 days"
    ExpiresByType image/png "access plus 3 days"
    ExpiresByType image/gif "access plus 3 days"
    ExpiresByType text/css "access plus 1 days"
    ExpiresByType text/javascript "access plus 1 days"
    ExpiresByType application/javascript "access plus 1 days"
    ExpiresByType application/x-javascript "access plus 1 days"
    ExpiresByType application/x-shockwave-flash "access plus 1 days"
    # ExpiresByType text/html "access plus 600 seconds"
    # ExpiresByType application/xhtml+xml "access plus 600 seconds"
</IfModule>

<IfModule deflate_module>
    BrowserMatch ^Mozilla/4 gzip-only-text/html
    BrowserMatch ^Mozilla/4\.0[678] no-gzip
    BrowserMatch \bMSIE\s(7|8) !no-gzip !gzip-only-text/html

    FilterDeclare Compression CONTENT_SET
    FilterProvider Compression DEFLATE Content-Type $text/html
    FilterProvider Compression DEFLATE Content-Type $text/xml
    FilterProvider Compression DEFLATE Content-Type $text/css
    FilterProvider Compression DEFLATE Content-Type $text/plain
    FilterProvider Compression DEFLATE Content-Type $image/svg+xml
    FilterProvider Compression DEFLATE Content-Type $application/x-httpd-php
    FilterProvider Compression DEFLATE Content-Type $application/xhtml+xml
    FilterProvider Compression DEFLATE Content-Type $application/xml
    FilterProvider Compression DEFLATE Content-Type $application/rdf+xml
    FilterProvider Compression DEFLATE Content-Type $application/rss+xml
    FilterProvider Compression DEFLATE Content-Type $application/atom+xml
    FilterProvider Compression DEFLATE Content-Type $text/javascript
    FilterProvider Compression DEFLATE Content-Type $application/javascript
    FilterProvider Compression DEFLATE Content-Type $application/x-javascript
    FilterProvider Compression DEFLATE Content-Type $application/x-font-ttf
    FilterProvider Compression DEFLATE Content-Type $application/x-font-otf
    FilterProvider Compression DEFLATE Content-Type $application/x-font-woff
    FilterProvider Compression DEFLATE Content-Type $font/truetype
    FilterProvider Compression DEFLATE Content-Type $font/opentype
    FilterChain Compression

    SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png|ico|zip|lzh|exe)$ dont-vary
    Header append Vary User-Agent env=!dont-vary
    Header append Vary Accept-Encoding env=!dont-vary
</IfModule>

FileETag None

# @deprecated mod_deflate
<IfModule mod_deflate.c>
    SetOutputFilter DEFLATE
    BrowserMatch ^Mozilla/4 gzip-only-text/html
    BrowserMatch ^Mozilla/4\.0[678] no-gzip
    BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html
    SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|png|ico)$ no-gzip dont-vary
    SetEnvIfNoCase Request_URI _\.utxt$ no-gzip
    #DeflateCompressionLevel 4
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE application/x-httpd-php
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/atom_xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/x-javascript

    AddOutputFilterByType DEFLATE application/x-font-ttf
    AddOutputFilterByType DEFLATE application/x-font-woff
    AddOutputFilterByType DEFLATE font/opentype
    AddOutputFilterByType DEFLATE image/svg+xml
</IfModule>
```

### VirtualDocRoot
#### 有効化

```
# for debian
sudo a2enmod mod_vhost_alias
sudo service apache2 reload
```

#### 設定の記述

```
VirtualDocumentRoot /var/www/%0/public_html
```

##### %{NUM} について

sub.example.com の場合

- %0 = sub.example.com
- %1 = sub
- %1+ = sub.example.com
- %2 = example
- %2+ = example.com

- %A.B = %Aで指定されたドメイン部分のB文字目
	- %1.1 = s
	- %1.2 = u
	- %1.3 = b

- %A.-B = %Aで指定されたドメイン部分の末尾からの文字数
	- %1.-1 = b
	- %1.-2 = u
	- %1.-3 = s

- %A.B+ = %Aで指定されたドメイン部分の文字数から以降全て
	- %1.1+ = sub
	- %1.2+ = ub
	- %1.3+ = b
	- %1.-1+ = sub
	- %1.-2+ = su
	- %1.-3+ = s

## module

### `mod_rpaf`/`mod_extract_forwarded`/`mod_remoteip`
プロキシ経由でもIPを正しく取得できるようにするモジュール

#### `mod_rpaf`

```
RPAFenable On
RPAFsethostname Off
RPAFproxy_ips 127.0.0.1
```

#### `mod_extract_forwarded`

```
MEForder refuse, accept
MEFrefuse all
MEFaccept 192.168.x.y
```

```
MEFaccept all
```

```
# 途中経路が複数ある場合は、直近のProxy で以下をセットする
RequestHeader unset X-Forwarded-For
RequestHeader unset Forwarded-For
```

#### `mod_remoteip`

```
LoadModule remoteip_module    modules/mod_remoteip.so
RemoteIPHeader X-Forwarded-For
```
