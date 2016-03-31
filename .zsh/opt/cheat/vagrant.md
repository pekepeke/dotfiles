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
