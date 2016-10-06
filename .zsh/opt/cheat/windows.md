
## Network

```
## ローカルエリア接続再起動
netsh interface set interface "ローカル エリア接続" disalbe
netsh interface set interface "ローカル エリア接続" enable
## wifi接続再起動
netsh int set int "ワイヤレス ネットワーク 接続" disable
netsh int set int "ワイヤレス ネットワーク 接続" enable
```

## msys2

```
# pacman バージョン確認
pacman -Sl | grep 'pacman '

# pacman >= 5.0.1.6403, 5.0.1-1
pacman -Syuu

# pacman >= 4.2.16187
update-core
pacman -Suu

# other
pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime msys2-runtime-devel
pacman -Suu

```

## WinMerge
### `EUC-JP`のカスタムコード
- 20932

