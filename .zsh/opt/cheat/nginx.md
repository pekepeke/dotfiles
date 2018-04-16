nginx
=====

## TCP Load Balancer

```
yum -y install pcre-devel zlib-devel
wget http://nginx.org/download/nginx-1.9.6.tar.gz
tar -xzf nginx-1.9.6.tar.gz
./configure --with-stream
make
make install
```

```
stream {
    upstream stream_backend {
        zone tcp_servers 64k;
        server 192.168.55.201:3308;
        server 192.168.55.202:3308;
        server 192.168.55.203:3308;
    }

    server {
        listen 3307;
        proxy_pass stream_backend;
        proxy_connect_timeout 1s;
    }

    upstream dns_udp_upstreams {
        # server ${DNS1_PORT_53_UDP_ADDR}:53;
        # server ${DNS2_PORT_53_UDP_ADDR}:53;
        server 192.168.55.201:53;
        server 192.168.55.202:53;

    }

    server {
        listen 53 udp;
        proxy_pass dns_udp_upstreams;
        proxy_timeout 1s;
        proxy_responses 1;
    }
}
```

## X-Accel
### X-Accel-Redirect [void|uri]
Nginx 側でファイルを返却させる.

### X-Accel-Buffering [yes|no]
proxy バッファリングを設定する.

### X-Accel-Charset [charset]
ファイルの charset を設定する.

### X-Accel-Expires [off|seconds]
内部的な nginx キャッシュ内のファイルの有効期限を設定する.
※ただし、Expires, Cache-Control などのheaderが返ってくるとキャッシュされない.

### X-Accel-Limit-Rate [off|bytes]
レート制限を設定する.

## コマンドライン

### 起動
```
sudo nginx
```
### 停止
```
sudo nginx -s stop
```

### 再起動
```
sudo nginx -s reload
```

### 設定ファイルのチェック
```
sudo nginx -t
service nginx configtest
nginx -t
```

## `status_module`
### 確認
```
nginx -V
```

### 設定
```
server {
    listen 80;
    server_name localngcheck;

    location /nginx_status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
}
```

### 状況確認

```
wget http://hostingfu.com/files/nginx/nginxstats.py
./nginxstats.py
```

## リクエスト制限(HttpLimitReqModule)

- `limit_req_zone $binary_remote_addr  zone=[name]:[size] rate=[rate];`
	- `$binary_remote_addr` - 公式でこの変数名
	- `[name]` - ゾーン名（公式では"one"という名称を使っている）
	- `[size]` - ゾーンの最大サイズ
	- `[rate]` - 毎秒/分/時 の最大リクエスト数。この数を超えると503を返す
	- `http`ディレクティブ

- `limit_req zone=[name] burst=[burst];`

	- `[name]` - `limit_req_zone` で設定したnameを設定
	- `[burst]` - `limit_req_zone`の[rate]で設定した上限を超えた場合の待ち行列数。ここを設定しないと、[rate]を超えた瞬間すぐに503になってしまう。
		- ※ この数値を超えたら503になる
	- `http`、`server`、`location`ディレクティブ

```
# limit_req_zoneはhttpディレクティブに設定
http {
    limit_req_zone $binary_remote_addr  zone=one:10m rate=50r/s;
    # 毎秒50リクエスト

    server {
        listen 80;
        server_name hogehoge.com;
        limit_req zone=one burst=100;
    }
}
```

##  その他設定
### `mod_rpaf`

```
real_ip_header X-Forwarded-For;
set_real_ip_from 0.0.0.0/0;
```

## 設定例
### メモ
- [画像リサイズサーバー](http://qiita.com/zaru/items/1c21d418d69c3505a91a)
- [HTTPS画像プロキシ](http://qiita.com/pine613/items/7fa474099240a0777a3f)

### ltsv

```conf
  log_format  ltsv  'domain:$host\t'
                    'host:$remote_addr\t'
                    'user:$remote_user\t'
                    'time:$time_local\t'
                    'method:$request_method\t'
                    'path:$request_uri\t'
                    'protocol:$server_protocol\t'
                    'status:$status\t'
                    'size:$body_bytes_sent\t'
                    'referer:$http_referer\t'
                    'agent:$http_user_agent\t'
                    'response_time:$request_time\t'
                    'cookie:$http_cookie\t'
                    'set_cookie:$sent_http_set_cookie\t'
                    'upstream_addr:$upstream_addr\t'
                    'upstream_cache_status:$upstream_cache_status\t'
                    'upstream_response_time:$upstream_response_time';
  access_log /var/log/nginx/access.log ltsv;
```

### php+php-fpm

```conf
server {
	listen 80;
	server_name localhost;
	error_page   500 502 503 504  /50x.html;
	location = /50x.html {
		root   /usr/share/nginx/html;
	}
	location ~ .php$ {
		fastcgi_pass   127.0.0.1:9000;
		fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_param  PATH_INFO $fastcgi_path_info;
		include        fastcgi_params;
	}
	if (!-e $request_filename) {
		rewrite ^/(.+)$ /index.php?url=$1 last;
		break;
	}
	## framework 系
	location ~ \.php$ {
		#    root           html;
		fastcgi_pass   127.0.0.1:9000;
		fastcgi_index  index.php;
		#fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include        fastcgi_params;
	}
}
```

### nginx+node(forever)

```conf
upstream node-app {
    server localhost:3000;
}

server {
	listen       80;
	server_name  localhost;
	proxy_redirect                          off;
	# proxy_redirect http:// $scheme://;
	proxy_hide_header       Server;
	proxy_hide_header       X-Powered-By;
	proxy_hide_header       X-AspNet-Version;
	proxy_set_header Host                   $host;
	proxy_set_header X-Real-IP              $remote_addr;
	proxy_set_header X-Forwarded-Host       $host;
	proxy_set_header X-Forwarded-Server     $host;
	proxy_set_header X-Forwarded-For        $proxy_add_x_forwarded_for;
	proxy_set_header        X-Forwarded-By    $server_addr:$server_port;
	proxy_set_header        X-Forwarded-Proto $scheme;
	# map $scheme $msiis      { http off; https on; } # compatibility
	# proxy_set_header        Front-End-Https   $msiis;

	### proxy-timeouts ###
	proxy_connect_timeout   6;
	proxy_send_timeout      60;
	proxy_read_timeout      60;

	### proxy-buffers ###
	proxy_buffering         on;
	proxy_buffer_size       8k;
	proxy_buffers           256 8k;
	proxy_busy_buffers_size    64k;
	proxy_temp_file_write_size 64k;
	proxy_temp_path         /var/spool/nginx/temp/;

	location / {
		proxy_pass http://node-app/;
	}
	error_page   500 502 503 504  /50x.html;
	location = /50x.html {
		root   /usr/share/nginx/html;
	}
}
```
<!--
## 設定例
### 

```conf
```
-->
