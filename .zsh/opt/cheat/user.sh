useradd www
passwd hogehoge
usermod -G wheel www
sudo usermod -G sudo,docker $(whoami)
sudo gpasswd -a ユーザー名 sudo

groupadd mysql
useradd -g mysql -d /var/empty/mysql -s /sbin/nologin mysql

