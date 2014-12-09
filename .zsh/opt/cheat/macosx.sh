## Finderのツールバーに追加
⌘キーを押下しながらDrag & Drop

## caffeinate でスリープを防ぐ
caffeinate brew update &
caffeinate open -a Safari
caffeinate -t 3600 &

## pkgutil でパッケージファイルを展開
pkgutil --expand test.pkg ~/Desktop/test/

## 同じアプリを複数開く
open -n /Applications/Safari.app

## App Store を使わずに OS X をアップデート
# アップデートの有無を確認
$ sudo softwareupdate -l

# 利用可能なアップデートを全てインストール
$ sudo softwareupdate -i -a

## icns を作成
mkdir -p applet.iconset
cd !$
cp path/to/icon_512x512.png .
mogrify -resize 512x512! icon_512x512.png
cd ..
iconutil -c icns applet.iconset
open .

