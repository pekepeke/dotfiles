## `systemd-nspawn`

```
machinectl pull-dkr --verify=no base/archlinux --dkr-index-url=https://index.docker.io
docker export -o mysql56.tar 9872d546b6d1f245f25b895ef4c05725d3fdba30d604c11801b000b78ac79d23
systemd-nspawn --ephemeral --directory mysql56 --setenv=MYSQL_ROOT_PASSWORD=notasecret --network-veth
```

