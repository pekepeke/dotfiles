ansible
=======
- http://inforno.net/articles/2013/10/15/ansible-tips

## 基本
### ループ処理

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

## インストール周り
### yum でのインストール

```
- name: Install git
  yum: name=git state=latest
```

### github からの clone
- poll と async は処理に時間が掛かる場合にタイムアウトしないように付ける。

```
- name: clone ffmpeg
  git: repo=git://source.ffmpeg.org/ffmpeg.git dest=/tmp/ffmpeg
  sudo: yes
  poll: 30
  async: 600
```

### make install

```
- name: "wget hoge src"
  command: wget -O http://example.com/hoge.tar.gz  creates=hoge.tar.gz

- name: "expand src"
  command: tar xvfz hoge.tar.gz creates=hoge

- name: install python3.3
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

## コマンド実行
### エラーを無視

```
- name: make qmail
  command: make chdir=/tmp/qmail-1.03
  ignore_errors: yes
```

### 特定のディレクトリにcdしてコマンド実行

```
- name: make qmail
  command: make chdir=/tmp/qmail-1.03
  sudo: yes
```

### コマンドの実行結果で分岐

```
- shell: hogehoge
  register: result
  ignore_errors: True

- debug: msg="hogehoge failed"
  when: result|failed

- shell: uname
  register: result
  ignore_errors: True

- debug: msg="uname success"
  when: result|success
```

## ファイル操作
### filesディレクトリにあるファイルをコピー

```
- name: create sshd_config
  copy: src=sshd_config dest=/etc/ssh/sshd_config mode=600
  sudo: yes
```

### templatesディレクトリにあるファイルをコピー

```
- name: Copy httpd.conf
  template: src=httpd.conf dest=/etc/httpd/conf/
  sudo: yes
```

### ファイルをコピーしたときに、所有者・グループ・パーミションを指定する

```
- name: create install.sh
  copy: src=install.sh dest=/home/myuser/scripts/ owner=myuser group=mygroup mode=755
  sudo: yes
```

### ファイルをダウンロード

```
- name: download php
  get_url: url=http://jp1.php.net/get/php-5.3.28.tar.gz/from/this/mirror dest=/tmp
```

## ファイルコピー

```
# remote -> remote
shell: rsync -a /path_to/source/  /path_to/dest/ creates=/path_to/dest/hoge
# local -> remote
local_action: command rsync -a /path_to/source/ {{ inventory_hostname }}:/path_to/dest/
```

### 設定ファイルを書き換える

```
 name: enalbe sudo without password if user belongs to the wheel group
 lineinfile: "dest=/etc/sudoers state=present regexp='^%wheel' line='%wheel ALL=(ALL) NOPASSWD: ALL'"
```

#### lineinfile - 単一行の追記、置換

オプション|説明
----------|-------------------------------------------------------------------------------------------------------------------------
dest *    |編集対象のファイルパスを指定します。
line      |挿入する、もしくは置換後の文字列を指定します。
regexp    |置換対象を正規表現で指定します。正規表現はPythonの書式に従います。
backup    |yesにすると、変更対象のバックアップを保存します。バックアップファイル名の書式は、元ファイル名.2015-04-20\@23:26:17~です。
create    |yesにすると、対象ファイルが存在しない場合は新規に作成します。
```
- name: set locale
    lineinfile: >
      dest=/etc/cloud/cloud.cfg
      line='locale: ja_JP.UTF-8'
- name: disable repo_upgrade
    lineinfile: >
      dest=/etc/cloud/cloud.cfg
      regexp='repo_upgrade\:'
      line='repo_upgrade: none'
```

#### replace - 複数行の置換

オプション名 |コメント
-------------|-------------------------------------------------------------------------------------------------------------------------
dest *       |置換対象のファイルパスを指定します。
replace      |置換後の文字列を指定します。
regexp       |置換対象を正規表現で指定します。正規表現はPythonの書式に従います。
backup       |yesにすると、変更対象のバックアップを保存します。バックアップファイル名の書式は、元ファイル名.2015-04-20\@23:26:17~です。

```
- name: set timezone
    replace: >
      dest=/etc/sysconfig/clock
      regexp='^ZONE="UTC"'
      replace='ZONE="Asia/Tokyo"'
```

#### ini_file - INI 形式のファイル編集

オプション名 |コメント
-------------|------------------------------------------------------------------------------------------------------------------------
dest *       |編集対象のファイルパスを指定します。
section *    |編集対象のセクション名を指定します。
option       |編集対象の行の名前を指定します。
value        |編集対象の行の値を指定します。
backup       |yesにすると、変更対象のバックアップを保存します。バックアップファイル名の書式は、元ファイル名.2015-04-20@23:26:17~です。

```
- name: ini_file module test
	ini_file: >
		dest=/home/ec2-user/test.ini
		section=section1
		option=hoge
		value=100
```

## 環境周り
### distribution判定

```yaml
- include: ubuntu.yml
     when: ansible_distribution == "Ubuntu"
```

### $ENV
ansible_facts で取得できない場合はstdoutを使うこともできる

```yaml
- shell: make
  environment:
    PATH: "/opt/local/bin:{{ ansible_env.PATH }}"

- shell: echo $PATH
  register: path

- shell: echo $PATH
  environment:
    PATH: "/opt/local/bin:{{ path.stdout }}"
```
