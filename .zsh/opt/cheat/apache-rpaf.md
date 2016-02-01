## `mod_rpaf`

```
RPAFenable On
RPAFsethostname Off
RPAFproxy_ips 127.0.0.1
```

## `mod_extract_forwarded`

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

## `mod_remoteip`

```
LoadModule remoteip_module    modules/mod_remoteip.so
RemoteIPHeader X-Forwarded-For
```

