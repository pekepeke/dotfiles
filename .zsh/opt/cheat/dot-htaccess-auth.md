# Env

```
SetEnvIf User-Agent "Ninja" deny_ua
SetEnvIf Referer "^http://www\.xxx\.jp" ref_ok
SetEnvIf Request_URI "/healthcheck" healthcheck

Order Allow,Deny
allow from all
Allow from env=healthcheck
Allow from env=ref_ok
deny from 61.115.
deny from env=deny_ua
# apache2.4
<RequireAll>
    Require all granted
    <RequireAny>
        Require env ref_ok
        Require env healthcheck
    </RequireAny>
    Require not env deny_ua
</RequireAll>
```

# EC2

```
SetEnvIf X-Forwarded-For "111\.111\.111\.111|222\.222\.222\.222" allowed_ip_addresses
Order Deny,Allow
Deny from All
Allow from env=allowed_ip_addresses
# EC2 apache2.4
<RequireAny>
    # Require ip 111.111.111.111
    # Require ip 222.222.222.222
    Require env allowed_ip_addresses
</RequireAny>
```

# Basic

```
$ htpasswd -cb .htpasswd test testpasswd
$ htpasswd -c .htpasswd test
```

```
AuthUserFile /home/hogehoge/.htpasswd
AuthGroupFile /dev/null
AuthName "Please enter your ID and password"
AuthType Basic
require valid-user
# apache 2.4
Require valid-user
```

# 特定のパスだけ basic をかける

```
Satisfy Any
AuthUserFile /var/www/html/public/.htpasswd
AuthGroupFile /dev/null
AuthName "Please enter your ID and password"
AuthType Basic

Order Deny,Allow
Allow from all

<Files ~ "^.(htpasswd|htaccess)$">
  deny from all
</Files>

<Files ~ "^admin">
  deny from all
  require valid-user
</Files>
```

