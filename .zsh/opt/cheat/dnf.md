# dnf
## 特徴
yumの後継となるコマンドという位置付けで、yumと同じサブコマンド、オプションを使用可能

| コマンド        |                                                                                                                                            | 実行内容 |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| install         | 指定したパッケージに加え、依存関係があるパッケージもインストールする（既にインストールされていた場合は更新する）                           |          |
| reinstall       | パッケージを再インストールする                                                                                                             |          |
| downgrade       | パッケージを以前のバージョンのものにダウングレードする                                                                                     |          |
| remove          | パッケージを依存関係のあるパッケージとともに削除する                                                                                       |          |
| autoremove      | 依存関係のためにインストールされていた不要なパッケージを削除する                                                                           |          |
| upgrade         | パッケージを更新する（※3）                                                                                                                 |          |
| upgrade-minimal | 不具合の修正や機能追加、セキュリティ対応など「重要な更新」だけを更新する                                                             |          |
| distro-sync     | 最新の利用可能なバージョンへインストール済みパッケージを同期する                                                                           |          |
| mark install    | 指定したパッケージを手動でインストールしたものとする（autoremoveの対象外とする、「dnf mark remove パッケージ名」でマークを削除） |          |
| info            | パッケージの情報を表示する                                      |          |
| list            | パッケージを一覧表示する                                        |          |
| deplist         | パッケージの依存性の一覧を表示する                                                                                                         |          |
| group           | パッケージグループのサマリーを表示する                                                                                               |          |
| search          | 指定した文字列でパッケージの詳細を検索する                                                                              |          |
| repoquery       | キーワードに一致するパッケージを検索する                                                                            |          |
| provides        | ファイル名などを指定して、該当するファイルを提供するパッケージを検索する                                                                   |          |
| repolist        | ソフトウェアリポジトリの構成を表示する                                                                                                     |          |
| makecache       | パッケージリストを格納したデータベース（リポジトリのメタデータ）をダウンロードし、キャッシュを作成／更新する                               |          |
| check           | ローカルのパッケージデータベースに問題がないかどうか確認する                                                                               |          |
| check-update    | 更新に利用できるパッケージを確認する                                                                                                       |          |
| clean           | キャッシュデータを削除する                                                                                                                 |          |
| shell           | 対話型のシェル（DNFシェル）を実行する                                                                                                      |          |
| updateinfo      | リポジトリの更新情報を表示する                                                                                                             |          |
| history         | パッケージのインストールや削除の履歴を表示する                                                                                             |          | 

```
# パッケージの更新
dnf upgrade --security
# セキュリティー関連パッケージの更新
dnf upgrade-minimal --security
# パッケージグループを更新
dnf group upgrade <グループ名>
# パッケージの削除
dnf erase [package]
# パッケージを検索
dnf search [package]
# パッケージ情報の全てから検索
dnf search all <検索文字列>
# glob表現に一致するインストール済み および 利用可能なパッケージを一覧表示
dnf list [expr]
# glob表現に一致するインストール済みのパッケージを一覧表示する。
# dnf list --installed [expr]
glob表現に一致する有効なすべてのリポジトリーでインストール可能なパッケージを一覧表示
dnf list --available [expr]
# リポジトリーの ID、名前、使用中のシステム上で 有効な 各リポジトリーでのパッケージ数を一覧表示
dnf repolist
# 有効および無効なリポジトリーの両方を一覧表示する。
dnf repolist all
```
## リポジトリ周り
設定は `/etc/yum.repos.d/` に配置されている
```
# リポジトリを追加
dnf config-manager --add-repo [repo]
# リポジトリを無効化
dnf config-manager --disable extras
# リポジトリを有効化
dnf config-manager --enable extras
```
