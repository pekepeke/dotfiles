## http://inforno.net/articles/2013/10/15/ansible-tips
## yum でのインストール

```
- name: Install git
  yum: name=git state=latest
```

## github からの clone
- poll と async は処理に時間が掛かる場合にタイムアウトしないように付ける。

```
- name: clone ffmpeg
  git: repo=git://source.ffmpeg.org/ffmpeg.git dest=/tmp/ffmpeg
  sudo: yes
  poll: 30
  async: 600
```

## filesディレクトリにあるファイルをコピー

```
- name: create sshd_config
  copy: src=sshd_config dest=/etc/ssh/sshd_config mode=600
  sudo: yes
```

## templatesディレクトリにあるファイルをコピー

```
- name: Copy httpd.conf
  template: src=httpd.conf dest=/etc/httpd/conf/
  sudo: yes
```

## ファイルをコピーしたときに、所有者・グループ・パーミションを指定する

```
- name: create install.sh
  copy: src=install.sh dest=/home/myuser/scripts/ owner=myuser group=mygroup mode=755
  sudo: yes
```

## ファイルをダウンロード

```
- name: download php
  get_url: url=http://jp1.php.net/get/php-5.3.28.tar.gz/from/this/mirror dest=/tmp
```

## エラーを無視

```
  ignore_errors: yes
```

## 特定のディレクトリにcdしてコマンド実行

```
- name: make qmail
  command: make chdir=/tmp/qmail-1.03
  sudo: yes
```

## ループ処理

```
- name: create dirs
  command: mkdir -p /tmp/{{item}}
  sudo: yes
  with_items:
      - dir_a
      - dir_b
      - dir_c
      - dir_d
```

# 設定ファイルを書き換える

```
 name: enalbe sudo without password if user belongs to the wheel group
 lineinfile: "dest=/etc/sudoers state=present regexp='^%wheel' line='%wheel ALL=(ALL) NOPASSWD: ALL'"
```

## ファイルコピー

```
# remote -> remote
shell: rsync -a /path_to/source/  /path_to/dest/ creates=/path_to/dest/hoge
# local -> remote
local_action: command rsync -a /path_to/source/ {{ inventory_hostname }}:/path_to/dest/
```

## make install

```
- name: "wget hoge src"
  command: wget -O http://example.com/hoge.tar.gz  creates=hoge.tar.gz

- name: "expand src"
  command: tar xvfz hoge.tar.gz creates=hoge

name: install python3.3
 shell: >-
   wget http://www.python.org/ftp/python/3.3.2/Python-3.3.2.tgz &&
   tar zxvf Python-3.3.2.tgz &&
   rm -f Python-3.3.2.tgz &&
   cd Python-3.3.2 &&
   ./configure --prefix=/usr/local/python3.3.2 --enable-shared &&
   make &&
   paco -D make install
   chdir=/usr/local/src creates=/usr/local/python3.3.2/bin/python3.3
```

