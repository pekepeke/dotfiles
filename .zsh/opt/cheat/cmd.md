## tail
### 指定した行以降の表示

```
grep -n "fuga" filename
tail -n +100 filename
```

## find 

```
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
# -l [階層数(5まで)] + -r == recursive
wget -r -l 0 http://www.mysite.co.jp/index.html

# -np = --no-parent
wget -r -np http://www.mysite.co.jp/path/to/index.html
```

