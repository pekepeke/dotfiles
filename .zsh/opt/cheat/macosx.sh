## mojave
### pyenv error

```
sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
```

## Lock

Cmd+Ctl+q

## Screenshot
| Shortcut Key                                           | description                                                                                 |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| 「Command」＋「Shift」＋「3」                          | デスクトップ全体を撮影                                                                                 |
| 「Command」＋「Shift」＋「4」                          | 選択範囲を撮影                                                                                         |
| 「Command」＋「Shift」＋「4」「スペース」              | カーソルがカメラ型に変わる→特定のウインドウやメニューバーをクリックして撮影                            |

| Shortcut Key                                           | description                                                                                 |
| 「Control」＋「Command」＋「Shift」＋「3」             | デスクトップ全体を撮影して、画像をクリップボードに転送                                                 |
| 「Control」＋「Command」＋「Shift」＋「4」             | 選択範囲を撮影して、画像をクリップボードに転送                                                         |
| 「Control」＋「Command」＋「Shift」＋「4」「スペース」 | カーソルがカメラ型に変わる→特定のウインドウやメニューバーをクリックして撮影→画像はクリップボードに転送 |


選択範囲を撮影する時に利用できるキーボードショートカット
キーボードショートカット	説明
「スペース」を押し続ける	選択範囲の大きさを固定して、選択範囲を動かすことが可能
「Shift」を押し続ける	選択範囲の縦または横どちらか一方の長さを固定
「Option」を押し続ける	選択範囲の中心を基点に選択範囲の大きさを変更
「Shift」＋「スペース」を押し続ける	選択範囲の大きさを固定して、縦または横の座標を固定して選択範囲を動かせる
「Shift」＋「Option」を押し続ける	縦または横の座標を固定して、選択範囲の中心を基点に選択範囲の大きさを変更
「Esc」	キャンセル
「Command」＋「.（ピリオド）」	キャンセル
グラブ.appで利用できるキーボードショートカット
キーボードショートカット	説明
「Command」＋「Shift」＋「A」	グラブ.appで選択範囲を撮影
「Command」＋「Shift」＋「W」	グラブ.appで特定のウインドウを撮影
「Command」＋「Z」	グラブ.appでデスクトップ全体を撮影
「Command」＋「Shift」＋「Z」	グラブ.appでタイマー撮影

## Finderのツールバーに追加
⌘キーを押下しながらDrag & Drop

# exclude resource fork
COPYFILE_DISABLE=1 tar cf folder.tar --exclude ".DS_Store" folder
COPYFILE_DISABLE=1 zip -r folder folder/ -x .DS_Store

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


## DiffMerge のフォント変更
mate ~/Library/Preferences/SourceGear\ DiffMerge\ Preferences

-----
[File]
Font=14::Ricty
[File/Printer]
Font=14::Ricty
[Folder]
[Folder/Printer]
Font=14::Ricty
-----

