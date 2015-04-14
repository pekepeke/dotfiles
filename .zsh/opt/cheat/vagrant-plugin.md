Vagrant plugins
====================
## sahara

```bash
### sandboxモード実行
vagrant sandbox on
### ロールバック
vagrant sandbox rollback
### コミット
vagrant sandbox commit
### sandboxモード終了(コミットしていない変更は削除)
vagrant sandbox off
### sandboxのステータス確認
vagrant sandbox status
```

## vagrant-vbox-snapshot

```bash
### スナップショットの取得
vagrant snapshot take <snapshot-name>
### 直前のスナップショットの復元
vagrant snapshot back
### 任意のスナップショットの復元
vagrant snapshot go <snapshot-name>
### スナップショットの削除
vagrant snapshot delete <snapshot-nam>
### スナップショットの一覧表示
vagrant snapshot list
```
