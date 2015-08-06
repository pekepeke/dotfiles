xdebug
======

## basic settings

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

## bash function

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
