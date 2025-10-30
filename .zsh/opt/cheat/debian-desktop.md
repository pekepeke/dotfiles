
## startup
- ~/.config/autostart/xxx.desktop

## capslock -> ctrl

```
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

sudo vi /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

##  ディレクトリ名の変更

```sh
LC_ALL=C xdg-user-dirs-update --force
LANG=C xdg-user-dirs-update --force
```

## 言語周りの変更

```sh
timedatectl # TZ確認
# TZ設定の更新
sudo timedatectl set-timezone Asia/Tokyo

locale # ロケール確認
# ロケールの更新
sudo locale-gen ja_JP.UTF-8
sudo update-locale LANG=ja_JP.UTF-8

localectl status # KB設定を確認
# キーボードレイアウトを日本語に変更
sudo localectl set-keymap jp
sudo localectl set-x11-keymap jp
```

## RTCにローカルタイムを使用

```sh
sudo timedatectl set-local-rtc 1 --adjust-system-clock
```
