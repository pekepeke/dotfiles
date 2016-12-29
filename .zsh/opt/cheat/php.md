## centos7

### compile

```
sudo yum install libxml2-devel bison bison-devel openssl-devel curl-devel libjpeg-devel \
	libpng-devel libmcrypt-devel readline-devel libtidy-devel libxslt-devel bzip2-devel -y

PHP_VER=5.6.22
wget "http://jp1.php.net/get/php-$PHP_VER.tar.bz2/from/this/mirror" -O php-$PHP_VER.tar.bz2
tar xjvf $PHP_VER.tar.bz2

# --with-apxs2
# --enable-maintainer-zts                \
./configure \
  --with-config-file-path=/etc           \
  --with-config-file-scan-dir=/etc/php.d \
  --with-pear                            \
  --with-pcntl                           \
  --with-mcrypt                          \
  --with-zlib                            \
  --with-curl                            \
  --with-bz2                             \
  --with-mhash                           \
  --with-pcre-regex                      \
  --with-openssl                         \
  --with-mysql=mysqlnd                   \
  --with-mysqli=mysqlnd                  \
  --with-pdo-mysql=mysqlnd               \
  --with-pdo-sqlite                      \
  --enable-ftp                           \
  --enable-cgi                           \
  --enable-mbstring                      \
  --enable-zip                           \
  --enable-sockets                       \
  --enable-sysvsem                       \
  --enable-sysvshm                       \
  --enable-bcmath                        \
  --enable-pcntl                         \
  --enable-modules=so                    \
  --enable-fpm                           \
  --enable-opcache                       \
  --disable-debug
```

## composer
### plugin

```
composer global require "hirak/prestissimo:^0.3"
composer global remove hirak/prestissimo
```

### remove cache

```
rm -rf ~/.cache/composer
```

### composer.json に package 追加

```
composer require phpunit/phpunit:3.7.*       # requireに追加
composer require phpunit/phpunit:3.7.* --dev # require-devに追加
```

### remove

```
composer remove jenssegers/mongodb
composer remove jenssegers/mongodb --update-with-dependencies
```

### self-upgrade
```
composer self-upgrade
# https://github.com/composer/composer/tags
composer self-update 1.0.0-alpha8
```

## xdebug
### basic settings

```
xdebug.remote_enable = on
xdebug.remote_handler = dbgp
xdebug.remote_host = 127.0.0.1
xdebug.remote_connect_back = 1
xdebug.remote_port=9000
xdebug.remote_autostart=on
; xdebug.remote_autostart=off
xdebug.remote_mode=req
xdebug.dump.GET = *
xdebug.dump.POST = *
```

### bash function

```
xdebug() {
  if [ "$1" = "on" ] ; then
    alias php="XDEBUG_CONFIG=\"remote_host=$(echo $SSH_CLIENT | awk '{print $1}') idekey=ECLIPSE_DBGP remote_autostart=1\" php"
    # alias php="XDEBUG_CONFIG=\"remote_host=$(echo $SSH_CLIENT | awk '{print $1}') idekey=phpstorm remote_autostart=1\" php"
  else
    unalias php
  fi
}
```
