useradd www
passwd hogehoge
# グループ変更
usermod -G wheel www
sudo usermod -G sudo,docker $(whoami)
# ユーザーをグループに追加
sudo gpasswd -a ユーザー名 sudo

# グループ作成
groupadd mysql
# ユーザー作成
useradd -g mysql -d /var/empty/mysql -s /sbin/nologin mysql

