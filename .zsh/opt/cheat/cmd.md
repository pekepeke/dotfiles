## BOM

```
echo -en '\xef\xbb\xbf'
```

## ln
### 相対パスでsymlink

```
ln -sr /path/to/file /path/to/link
```

## curl
### curlで異なるFQDNにhttpsアクセスする方法

```
curl -H 'Host:www.example.com' --resolve 'www.excample.com:443:10.0.0.2' https://www.example.com/
```

## xargs
### 対象0件でもエラーをださない

```
find /hoge/fuga -ctime +30 -type f -print | xargs --no-run-if-empty rm
```

## ファイルの空き容量確認

```
du -x -s ./* | sort -n
du -h --max-depth=1 /
```

## grep

```
# -r リンクを辿らずディレクトリを検索
# -R リンクをたどってディレクトリを検索

## 文字エンコーディング無視して grep
grep -UR fuga ./

## マッチ部分のみ抽出
grep -o "<script[^>]*>"

## perl正規表現
grep -P "\d{3}"

## 「」で囲まれている中身だけ表示
grep -oP '(?<=「).+(?=」)'
```

## perl
### json encode

```
perl -pe 's/(\\(\\\\)*)/$1$1/g; s/(?!\\)(["\x00-\x1f])/sprintf("\\u%04x",ord($1))/eg;'
```

### camerlize/underscore

```
# camelize
echo $str | sed -re "s/(^|_)(.)/\U\2/g"
echo $str | perl -pe 's/(|)./uc($&)/ge;s///g'

# underscore
echo $Str | sed -r -e 's/^([A-Z])/\L\1\E/' -e 's/([A-Z])/_\L\1\E/g'
echo $Str | perl -pe 's/(^[A-Z])/lc($&)/ge;s/([A-Z])/_$&/g;s/([A-Z])/lc($&)/ge'
```

### quotemeta

```
echo "hoge\np#iyo" | perl -ne 'print quotemeta;'
```

### 置換

```
perl -pe 's/hoge/fuga/g' path/to/file
perl -pi -e 's/hoge/fuga/g' path/to/file
perl -pi.bak -e 's/hoge/fuga/g' path/to/file
perl -0pi -e 's/ho\nge/fuga/g' path/to/file
```

### etc

```
# N行目を表示する
perl -ne 'print if $.==10'
# 最後の行を表示する
perl -ne '$x=$_; END{print $x}'
# 単語数をカウントする
perl -anE '$n+=@F; END{say $n}'
# 行数をカウントする
perl -nE 'END{say $.}'
# 逆順出力をする
perl -ne 'unshift @a,$_; END{print @a}'
# タブ区切りの2列目で uniq
perl -F'\t' -ane 'print if !$a{$F[1]}++'
# 行番号を付ける
perl -pe 's/^/$. /'
# コメント行を削除する
perl -ne 'print if !/^#/'
# 複数行コメントの場合
perl -ne 'print if !(/\/\*/../\*\//)'
```

## tmux
### 全部の画面に同じコマンドを送る


```
Ctrl+b :set-window-option synchronize-panes on
```

## netcat

```
## 単体ポート（80番HTTPの通信確認）
nc -zv <ip address> 80
## 複数ポート（22、80、8080の通信確認）
nc -zv <ip address> 22 80 8080
## ポートレンジ指定
nc -zv <ip address> 20-30
```

## diff
### 差分がないところだけ出力する

```
# http://www.kabegiwablog.com/entry/2018/02/20/090000
diff --old-line-format='' --unchanged-line-format='%L' --new-line-format='' foo.txt bar.txt
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
### メタ文字

```
^   先頭
$   後尾
.   任意の 1 文字
*   直前の文字の 0 回以上の繰り返し
\+  直前の文字の 1 回以上の繰り返し
\?  直前の文字が 0 回または 1 回のみ出現
[]  文字クラス、[abc0-9] ならば数字と a, b, c のどれか 1 文字
\|  OR、[ab|ap] ならば ab または ap
\{3\}   直前の文字が 3 回だけ出現
\{3,5\} 直前の文字が 3〜5 回出現
\b  単語区切り
```

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
# 3行目～末行表示
sed -n -e 3,$p
```

### 拡張正規表現(-E)
- `+?{}()|` のバックスペースの追加が不要になる。

### 複数行書き換え

```
```

### その他便利系

```
# https://qiita.com/hirohiro77/items/7fe2f68781c41777e507
# '#START'から'#END'く括られた範囲で置換をする
sed -e '/#START/,/#END/ s/YYYYMM/201603/g' source.txt
# '#SKIP'が出たら次の行(N;)は読み飛ばす、数行読み飛ばす場合はN;N;みたいにする
sed '/#SKIP/{N; s/YYYY/2016/g}' source.txt

# タブをスペースに変換
sed -e 's/<tab>/<space>/g'
# 複数のスペースを1つのスペースに変換
sed -e 's/<space><space>*/<space>/g' 
# ホワイトスペースを1つのスペースに変換
sed -e 's/[<space><tab>][<space><tab>]*/<space>/g'　
# 行頭のホワイトスペースを削除
sed -e 's/^[<space><tab>]*//'
# 行末のホワイトスペースを削除
sed -e 's/[<space><tab>]*$//'
# textを含んだ行を削除
sed -e "/text/d"

# 空白行を削除
sed -e '/^$/d'
# 45行毎に改行を入れる
sed 's/.\{45\}/&\n/g' source.txt
```


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
iconv -c -f SJIS -t UTF8 # 機種依存文字無視
```

## openssl

```
# 暗号化
echo "This is AES TEST" | openssl enc -aes-256-cbc -e -base64 -pass pass:testpass
# 復号化
echo "U2FsdGVkX19qGJqg81dkwjjYecx6F5KCFiKhRDOsSbqCIjP/XJ+fKPbLLtQpUqU0" | openssl enc -aes-256-cbc -d -base64 -pass pass:testpass

# 暗号化方式一覧
openssl list-cipher-commands
# ファイルから暗号化/復号化
openssl aes-256-cbc -e -in rawtext.txt -out encrypted.txt -pass file:./password.txt
openssl aes-256-cbc -d -in encrypted.txt -out decrypted.txt -pass file:./password.txt

# 直接入力から暗号化/復号化
openssl aes-256-cbc -e -in rawtext.txt -out encrypted.txt
openssl aes-256-cbc -d -in encrypted.txt -out decrypted.txt

# 接続確認
openssl s_client -connect imap.softbank.jp:993 -msg

# ssl2/3確認
openssl s_client -ssl2 -connect imap.softbank.jp:993
openssl s_client -ssl3 -connect imap.softbank.jp:993
# tlsの確認
openssl s_client -tls1 -connect imap.softbank.jp:993
# cipherの確認
openssl cipher -v
openssl s_client -tls1 -connect 接続先:ポート -ciper サイファ
```

## sudo
### visudo -f /etc/sudoers.d/wheel

```
# %wheel ALL=(ALL) NOPASSWD: ALL
%wheel ALL=(ALL) ALL
Defaults:%wheel !requiretty
Defaults:%wheel env_keep += SSH_AUTH_SOCK
```

## df/du

```
# 全体のディスク容量を確認
df -h
# ディスク容量の内訳を確認
du -sh /path/to/dir/*
du -h --max-depth 2 /*
du -s ./* | sort -n
```
