pacman
======

## 設定ファイル
/etc/makepkg.conf - 自分でパッケージを build するときの設定
/etc/pacman.conf - リポジトリの設定をするファイル
/etc/pacman.d/mirrorlist - pacman で使うリポジトリミラーサーバー
/var/log/pacman.log

## コマンド

```bash
## データベースの更新
pacman -Sy
## リポジトリのリスト更新、mirrorlist の更新
pacman -Syy
## リポジトリリストとパッケージのアップデート
pacman -Syu

## パッケージのインストール
pacman -S [package]
## パッケージの検索
pacman -Ss [query]
## パッケージの情報を調べる
pacman -Si [package]
## パッケージのアンインストール
pacman -Rsn [package]
## インストールしたパッケージの情報を調べる
pacman -Qi [package]
## パッケージによってインストールされたファイルを調べる
packan -Ql [package]
## ファイルがどのパッケージによってインストールされたのか調べる
packan -Qo [file]
## パッケージの依存関係を調べる
pactree [package]
## パッケージキャシュの削除
paccache -r
```````

## msys2

```
update-core
## update-core が存在しない場合
pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime
## もしくは
pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime msys2-runtime-devel

# exit して mintty を再起動する

## 全体のパッケージのupdateを行う
pacman -Su

## fork エラーが発生したら、該当のパッケージを手動で更新する
pacman -S [package1] [package2]
```````


