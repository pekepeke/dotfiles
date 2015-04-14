## boxcutter

```bash
# https://github.com/boxcutter
git clone https://github.com/boxcutter/centos.git

cd centos-vm
vim centos65.json

vim http/ks6.cfg
----
lang ja_JP.UTF-8
timezone Asia/Tokyo
----

make list

make virtualbox/centos65
```

## xxx.json
### builders

| 項目名                  | 説明        |
|:------------------------|------------:|
| type                    | 何の仮想インスタンスを作成するかを指定する項目ですAWSのインスタンスとかも指定可能。今回はvirtualboxなので 「virtualbox-iso」を記載 |
| vm_name                 | デフォルトのvm名になりますVagrantでもオーバーライドできるの記載しなくても問題ない |
| boot_wait               | 最初にVirtualboxが起動bootするまでの待ち時間 |
| disk_size               | Virtualboxのディスク容量の指定適当に多めで |
| guest_os_type           | CentOSx86系なら「RedHat_64」を指定。typeの一覧は```VBoxManage list ostypes``` でわかる|
| iso_checksum            | isoのchecksum。わからない場合は```md5 作るOS.iso```と叩けばわかる|
| iso_url                 | isoのDL先のURL。何故かHTTPしかサポートしていなかった|
| ssh_username            | sshユーザー名。vagrantと連携したいならユーザー名はvagrantにしといたほうが楽かも|
| ssh_password            | sshユーザーのパスワード|
| ssh_port                | 何も考えずに22でいいでしょう|
| ssh_wait_timeout        | SSHの接続時間|
| shutdown_command        | シャットダウンコマンド |
| guest_additions_path    | Virtualboxのguest_additionsのパス |
| virtualbox_version_file | VirtualBoxのバージョン番号なんでしょう |
| vboxmanage              | Virtualboxのインスタンスの設定。今回はメモリを2G、CPUCore数を2としている |
|http_directory           | インストール時にローカルにWebサーバをたててkickstartなどの設定情報を持っていくための設定です。kickstartって何？って方は[kickstartでCentOS6の自動インストール](http://wg.drive.ne.jp/miura/archives/2208)をみてください|
|boot_command             | boot時のkickstartを実行するときのks.cfgの場所を指定する|

### post-processors

```packer.json（一部抜粋）
 "post-processors": [
    {
      "type": "vagrant",
      "output": "./packer/vagrant-boxes/CentOS-6.4-x86_64-minimal.box"
    }
  ]
```

| 項目名 | 説明 |
|:-----------|------------:|
| type | vagrantのボックス作る場合はvagrantで|
| output | vagrantのボックス作った後の.boxの吐き出し場所の指定です|


