## vb.customize
### NIC変更

```ruby
vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
```

### 時刻同期させない

```ruby
vb.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 1]
```

### cpu, kvm

```
vb.customize ["modifyvm", :id, "--paravirtprovider", "kvm"]
vb.customize ["modifyvm", :id, "--cpus", "2", "--ioapic", "on"]
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
yum clean all
yum clean packages
rm -rf ~/.cache/pip
sudo rm -rf /root/.cache/pip
sudo sh -c 'find /var/log -type f | while read f; do echo -ne "" > $f; done;'
ls /var/tmp
ls /tmp
ls /var/cache/yum

sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
export HISTSIZE=0
rm ~/.bash_history
rm ~/.viminfo
sudo rm /root/.viminfo
sudo rm -rf /root/.cache/pip


exit 
vagrant package --output centos7.box
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
