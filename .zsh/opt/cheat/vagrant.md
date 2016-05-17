## NIC変更

```
vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
```

## vagrant package

```
vagrant box add vm_name ./package.box
```

### mac アドレスマッピング無効化

```
# パッケージングする前のゲストOS側でMACアドレスとのマッピングを無効にしておきます
sudo ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules

# ※機能を再度有効にしたい場合は、該当ファイルを削除してネットワークを再起動することで再度マッピングされる
# rm -rf /etc/udev/rules.d/70-persistent-net.rules
```

#### centos 7の場合

```
rm /etc/udev/rules.d/70-persistent-ipoib.rules
```

### box ファイル軽量化
- https://gist.github.com/adrienbrault/3775253

```
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
rm ~/.bash_history
```

## disk 増設

```
# ディスク増設
VBoxManage clonehd "box-disk1.vmdk" "box-disk1.vdi" --format vdi
VBoxManage showhdinfo box-disk1.vdi
VBoxManage modifyhd box-disk1.vdi --resize 20480 # 20G

# vdi を使用する場合、vmdk を削除し vdi を接続する
VBoxManage showhdinfo box-disk1.vdi
VBoxManage storagectl [udid] --name "SATA Controller" --remove
VBoxManage storagectl [udid] --name "SATA Controller" --add sata
VBoxManage storageattach [udid] --storagectl "SATA Controller" --type hdd --medium box-disk1.vdi --port 0

# vdi -> vmdk
VBoxManage clonehd "box-disk1.vdi" "box-disk2.vmdk" --format vmdk
## 
VBoxManage showvminfo [vmname] | grep ".vmdk"
BoxManage storageattach [vmname] \
--storagectl "SATA" --port 0 --device 0 \
--type hdd --medium box-disk2.vmdk
VBoxManage showvminfo [vmname] | grep ".vmdk"

sudo fdisk -l
sudo resize2fs /dev/sda1

```
