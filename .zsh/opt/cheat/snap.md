# snap
```sh
# インストール
snap install [package]
# 直インストール
snap install --dangerous _/path/to/snap
# edge チャネルからインストール
snap install [package] --channel=latest/edge
# パッケージの詳細表示
snap info [package]
# 削除
snap remove [package]
# 検索
snap find [package]
# snap の更新
snap refresh
# パッケージの更新
snap refresh --list
# インストール済みのパッケージのチャネルを変更
snap refresh [package] --channel=latest/edge
# パッケージのロールバック
snap revert [package]
# インストール済パッケージを表示
snap list

# ~/snap を隠す
echo snap >> ~/.hidden
```

