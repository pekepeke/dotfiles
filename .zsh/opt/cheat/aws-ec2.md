## EC2 ボリューム拡張
- EC2インスタンスを停止する
- EC2インスタンスのEBS Volume からスナップショットを作成
	- 現行の volume id をメモしておく
- スナップショットから Create Volume を実施する
	- volume id をメモしておく
- EC2 インスタンスから既存のEBS Volume をデタッチし、新しいEBS Volume をアタッチする(Volumes から実施)
	- デタッチ時に既存の /dev/xxx を確認しておく
- EC2 インスタンスを起動し resize2fs を実行

```
df -h
sudo resize2fs /dev/sda1
df -h
```

