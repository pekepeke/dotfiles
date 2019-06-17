## いろいろ詳しいページ
http://mobilehackerz.jp/archive/wiki/index.php?%BA%C7%BF%B7ffmpeg%2F%A5%D3%A5%C7%A5%AA%A5%AA%A5%D7%A5%B7%A5%E7%A5%F3

## json 取得

```
ffprobe -i example.mp4 -of json -show_streams 2>/dev/null
```


## rotate
### rotateが90の場合

```
ffmpeg -i 入力ファイル名 -vf transpose=1 -metadata:s:v:0 rotate=0 出力ファイル名
```
- -vf transpose=1で映像を右に90度回転します。
- -metadata:s:v:0 rotate=0で元の回転情報を削除します。

### rotateが270の場合
```
ffmpeg -i 入力ファイル名 -vf transpose=2 -metadata:s:v:0 rotate=0 出力ファイル名
```
- -vf transpose=1で映像を左に90度回転します。

### rotateが180の場合
```
ffmpeg -i 入力ファイル名 -vf hflip,vflip -metadata:s:v:0 rotate=0 出力ファイル名
```


## extract voice
```
ffmpeg -i input.mp4 output.mp3
```

## make thumbnail
```
ffmpeg -ss 1 -i input.mp4 -vframes 1 -f image2 -s 320x240 1.jpg
ffmpeg -ss 6 -i input.mp4 -vframes 1 -f image2 -s 320x240 6.jpg
# 0sec-50 frame
ffmpeg -ss 0 -i input.mp4 -vframes 50 -f image2 %04d.jpg
# rotate=90
ffmpeg -ss 1 -i imput.mp4 -vframes 1 -f image2 -s 270x480 1.jpg 
```

## Tips
### どんな解像度・縦横比の動画も一発で指定のサイズにするffmpegコマンド
http://sogohiroaki.sblo.jp/article/183618558.html
```
ffmpeg -i "input.mp4" -vf "yadif=deint=interlaced, scale=w=trunc(ih*dar/2)*2:h=trunc(ih/2)*2, setsar=1/1, scale=w=1920:h=1080:force_original_aspect_ratio=1, pad=w=1920:h=1080:x=(ow-iw)/2:y=(oh-ih)/2:color=#000000" -pix_fmt yuv420p "output.mp4"
ffmpeg -i "input.mp4" -vf "yadif=deint=interlaced, scale=w=trunc(ih*dar/2)*2:h=trunc(ih/2)*2, setsar=1/1, scale=w=$W:h=$H:force_original_aspect_ratio=1, pad=w=$W:h=$H:x=(ow-iw)/2:y=(oh-ih)/2:color=#000000" -pix_fmt yuv420p "output.mp4"
```

### make animation gif
```
# jpeg2avi
ffmpeg -f image2 -i image%d.jpg video.avi
# avi2gif
ffmpeg -i video.avi -pix_fmt rgb24 -loop_output 0 out.gif
```

