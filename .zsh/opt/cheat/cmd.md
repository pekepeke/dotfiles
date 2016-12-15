## xargs
### 対象0件でもエラーをださない

```
find /hoge/fuga -ctime +30 -type f -print | xargs --no-run-if-empty rm
```

## grep

```
## 文字エンコーディング無視して grep
grep -UR fuga ./
```

## tail
### 指定した行以降の表示

```
grep -n "fuga" filename
tail -n +100 filename
```

## find 

```
# マルチバイトファイル名の検出
LANG=C find ./ | LANG=C grep -v '^[[:cntrl:][:print:]]*$'

# 50日以前に修正されたもの
find . -mtime +50
# 50日以内に修正されたもの
find . -mtime -50

# ログの一括削除
find ./log -mtime +60 -name '*.log' | xargs --no-run-if-empty rm

# depth
find . -maxdepth 1
```

## op

```
[ file1 -nt file2 ] && echo "file1 newer"
[ file1 -ot file2 ] && echo "file1 older"
```

## touch

```
# タイムスタンプ変更
touch -d "2003/1/1 00:00:00" hoge
# 修正時刻のみ変更
touch -m -t "2003/1/1 00:00:00" hoge
# アクセス時刻のみ変更
touch -a -t "2003/1/1 00:00:00" hoge
```

## sed
### 特定行の書き換え

```
# 3行目のみ
sed -e '3s/xxx/yyy/g'
# 3-5 行目を書き換え
sed -e '3,5s/xxx/yyy/g'
# 3-末行を書き換え
sed -e '3,5s/xxx/yyy/g'
```

### 特定行の削除

```
# 1-5 行目を削除
sed 1,5d
```

### 特定行の抽出

```
# 先頭行表示
sed -n -e 1p
# 末行表示
sed -n -e \$p
```

### 拡張正規表現(-E)
- `+?{}()|` のバックスペースの追加が不要になる。

## trap

```
tmpdir=`mktemp -d`
trap "rm -rf $tmpdir" 0 1 2 3 15
```

## incron, incrontab
- ファイル変更等のイベント時に指定のジョブを実行させるもの
	- linux のみでしか使えない(2.6.13 以降)

### install
```
yum install incron
apt-get install incron
```

### `incrontab -e`

```
/home/hoge/foo IN_CREATE, IN_DELETE /home/hoge/bin/script.sh $@/$# $%
```

#### 特殊ワイルドカード
- `$$`
	- a dollar sign
- `$@`
	- the watched filesystem path
- `$#`
	- the event-related file name
- `$%`
	- the event flags (textually)
- `$&`
	- the event flags (numerically) 

#### イベント一覧

```
incrontab -t
incrontab -t | sed -e 's/,/\n/g'
```

## wget

```
# basic
wget --http-user=fuga --http-passwd=piyo http://www.example.com
# -l [階層数(5まで)] + -r == recursive
wget -r -l 0 http://www.example.com

# -np = --no-parent
wget -r -np http://www.example.com

# jpg ファイルのみ取得
wget -r -l 1 -Ajpg http://www.example.com
# jpg ファイル除外
wget -r -l 1 -Rjpg http://www.example.com
# yimg.jp, ytimg.jp も取得対象に追加
wget -r -l 1 -Ajpg -H -Dyimg.jp,ytimg.jp http://www.example.com
# 1秒ウェイトをかける
wget -r -l 1 -Ajpg -H -Dyimg.jp,ytimg.jp -w 1 http://www.example.com
```

## 圧縮ファイル

```
# 中身表示
tar tvf ./test.tar
tar tvfz ./test.tar.gz
tar tvfj ./test.tar.bz2
zipinfo ./test.zip

# 特定ファイルの展開
##   --strip=1 で展開時のディレクトリ作成を抑止
##   docker/docker 抽出したいファイル
##  -C [dir] 展開先
 curl -fsSL path/to/file.tgz \
  | tar -xzC /usr/local/bin --strip=1 bin/fuga

```

## iconv

```
iconv -l #  文字コード表示
iconv -f SJIS -t UTF8
iconv -f EUCJP -t UTF8
iconv -f ISO2022JP -t UTF8
```
