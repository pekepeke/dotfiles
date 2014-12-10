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

# Resize(retain aspect ratio)
sips -Z 640 *.jpg
# Resize(force resize)
sips -Z 768 1024 *.jpg
# convert file format
sips -s format png test.jpg --out test.png
for i in *.jpeg; do sips -s format png $i --out Converted/$i.png;done

# show desktop
/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control 1
# app switch
/Applications/Mission\ Control.app/Contents/MacOS/Mission\ Control 2
