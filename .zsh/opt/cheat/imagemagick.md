ImageMagick
===========

## convert
### 基本
- https://shimoju.org/2017/11/12/imagemagick/

```
# 回転 (rotate)
## -rotateで指定した角度回転する
convert -rotate 90 original.jpg rotate.jpg
## 上下反転
convert -flip original.jpg flip.jpg
## 左右反転
convert -flop original.jpg flop.jpg
## 上下左右反転
convert -flip -flop original.jpg flipflop.jpg

# サンプル (sample)
## ピクセルを間引く
convert -sample 10% original.jpg sample.jpg
## 10%になるようにピクセルを間引いたあと、1000%になるように拡大→元画像と同じサイズでモザイクがかかる
convert -sample 10% -sample 1000% original.jpg mosaic.jpg

# リサイズ (resize)
## デフォルトではアスペクト比を変えない：指定した幅・高さに収まるようにリサイズされる
convert -resize 400x400 original.jpg resize.jpg
identify resize.jpg resize.jpg JPEG 400x267 400x267+0+0 8-bit sRGB 37116B 0.000u 0:00.000
## !をつけるとアスペクト比を無視して指定した値にリサイズする
convert -resize 400x400! original.jpg resize2.jpg
## 幅または高さのみ指定できる
convert -resize 400x original.jpg resize3.jpg

# エッジ検出 (edge)
## 不連続に変化している箇所を検出する
convert -edge 5 original.jpg edge.jpg
## 値を変化させてみよう
convert -edge 10 original.jpg edge2.jpg
convert -edge 1 original.jpg edge3.jpg

# 切り抜き (crop)
## -gravityで基準点を指定し、-crop widthxheightで切り抜くサイズを指定
convert -gravity center -crop 200x200+0+0 original.jpg crop.jpg
## +/-で基準点からのx,y座標を指定できる
## 画像右上を基準に、xに140px,yに50px移動し、その点から200x200px切り抜く
convert -gravity northeast -crop 200x200+140+50 original.jpg crop.jpg

# 塗り足し (extent)
## 指定したサイズになるように余白を追加する.正方形のサイズが必要なのに4:3の画像しかないときなどに便利
convert -background black -gravity center \
			  -extent 800x800 original.jpg extent.jpg
## 余白の色は-backgroundで指定する. PNG(透過が扱えるフォーマット)であれば、-background transparentで透過できる
convert -background transparent -gravity north \
			-extent 1000x1000 original.jpg extent.png
## 文字の画像を作る
convert -background transparent \
			  -fill '#ff6060' -font Arial -pointsize 128 label:LGTM lgtm.png
## 指定サイズで作成
$ convert -size 400x200 -gravity center -background transparent \
			-fill '#ff6060' -font Arial -pointsize 128 label:LGTM lgtm.png

# 合成 (composite)
## original.jpgの上にlgtm.pngを合成して、compose-over.jpgとして出力
convert original.jpg lgtm.png -gravity center \
			  -compose over -composite compose-over.jpg
## -geometryで基準点から移動
convert original.jpg lgtm.png -gravity center -geometry +150+50 \
			-compose over -composite compose-over.jpg

# 描画モード (blend mode)
## 重ねられた画像をどのように合成するかを指定できる (参考: http://imagemagick.rulez.jp/archives/672)
## 感覚をつかむにはGIMPのドキュメントがわかりやすい https://docs.gimp.org/2.8/ja/gimp-concepts-layer-modes.html
## -composeで描画モードを指定する

### 乗算 (multiply)
convert original.jpg lgtm.png -gravity center -geometry +150+50 \
			  -compose multiply -composite compose-multiply.jpg

### オーバーレイ (overlay)
convert original.jpg lgtm.png -gravity center -geometry +150+50 \
			  -compose overlay -composite compose-overlay.jpg

### 減算 (subtract)
convert original.jpg lgtm.png -gravity center -geometry +150+50 \
			  -compose subtract -composite compose-subtract.jpg

```

### 使い方
- http://www.imagemagick.org/Usage/color_mods/
- https://qiita.com/mtakizawa/items/a74bd91f7b3835976461
- http://imagemagick.rulez.jp/

```
# 1x1 transparent
convert -size 1x1 xc:none dummy.gif
# グレースケール変換
convert  test.png  -colorspace Gray   gray_colorspace.png

# 形式変換
convert ファイル名.jpeg ファイル名.pdf
# jpeg 圧縮率を90%に
convert P001.jpg -quality 90 converted_P001.jpg
ls *.jpg | xargs -I{} convert {} -quality 90 -verbose converted_{}

# 輝度，彩度の変更
# 「⁠輝度(Lightness)」「⁠彩度(Saturation)」「⁠色相(Hue)」の順にパーセトン値で指。値が指定されない場合は100％が指定される
# convert P001.jpg -modulate [Lightness],[Saturation],[Hue] converted_P001.jpg
convert P001.jpg -modulate 110,130 converted_P001.jpg

# トーンカーブ
# convert P001.jpg -linear-stretch [黒の基準点]x[白の基準点]% converted_P001.jpg
# 黒の基準点は変更せずに，明度の上位1％の点を白の基準点にする
convert P001.jpg -linear-stretch 0x1% converted_P001.jpg
# http://q.hatena.ne.jp/1288094046
# convert INPUT_IMG -sigmoidal-contrast [CONTRAST]x[MID-POINT] OUTPUT_IMG
convert test.png -sigmoidal-contrast 10x10% test_mod.png
```

## identify
- 画像の情報を出力できる
- サイズをさっと知りたいときとか、大量の画像の中からサイズが違うものを探したりとかに便利
- フォーマット文字列はこちら参照：[Format and Print Image Properties @ ImageMagick](https://www.imagemagick.org/script/escape.php)

```
identify *.jpg
identify -format '{"width": %w, "height": %h}' *.jpg | jq
identify -format '%wx%h %f\n' *.jpg | grep -v 800x533
```
