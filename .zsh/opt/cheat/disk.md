## 容量調査

```
# -h は任意の単位を付与するオプション

# カレントディレクトリの容量確認
du -h --max-depth 1
# パーティションの容量確認
df -h
# ユーザーの制限容量確認
quota
```

## デバイス名の確認

```
fdisk -l
# fdisk -l で表示されない場合
dmesg | grep hd
fdisk -l /dev/sda
```
