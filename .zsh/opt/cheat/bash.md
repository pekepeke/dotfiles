## エラーとかだす

```
set -xe
# 戻す
set +xe
```

## デフォルト値

```
FUGA=${HOGE-fuga}
```

## 置換

| パターン                       | 動作                                 | 典型的な使用例        |
|--------------------------------|--------------------------------------|-----------------------|
| ${変数%マッチパターン}         | 後方からの検索で最短マッチ部分を削除 | ${HOGE%/*}でdirname   |
| ${変数%%マッチパターン}        | 後方からの検索で最長マッチ部分を削除 | あまり使わない        |
| ${変数#マッチパターン}         | 前方からの検索で最短マッチ部分を削除 | あまり使わない        |
| ${変数##マッチパターン}        | 前方からの検索で最長マッチ部分を削除 | ${HOGE##*/}でbasename |
| ${変数/検索文字列/置換文字列}  | 最初にマッチしたもののみ文字列を置換 |                       |
| ${変数//検索文字列/置換文字列} | 全ての文字列を置換                   | ${HOGE//foo/bar}      |

## Bashで自身の関数名と呼び出し元の関数名を取得
- https://qiita.com/koara-local/items/5e3fd1d0c9080ea61b5b

```
local fn=${FUNCNAME[0]}
local caller=${FUNCNAME[1]} # 呼び出し元の関数名
```

## logger

```bash
exec 1> >(logger -s -t $(basename $0)) 2>&1
exec > >(tee log.log) 2>&1
# 標準出力をリダイレクト
exec > log.log
# 標準エラーを標準出力に
exec 2>&1
```

## 行を逆順に変換

```
cat file | rev | tac | rev | command
```

## ROOTかどうかをチェックする

```
if [ ${EUID:-${UID}} = 0 ]; then
    echo 'I am root.'
fi
if [ `whoami` = 'root' ]; then
    echo 'I am root.'
fi
if [ $UID = `id -u root` ]; then
    echo 'I am root.'
fi
if [ $(id -u) = $(id -u root) ]; then
    echo 'I am root.'
fi
```



## 配列・ハッシュ

```bash
declare -a array=(1 2 3)
declare -A H
H["key1"]="value1"
H["key2"]="value2"
H["key3"]="value3"

H=( \
  ["key1"]="value1" \
  ["key2"]="value2" \
  ["key3"]="value3"
)

for i in ${!H[@]}; do
  echo "${i} => [${H[$i]}]"
done
```

## 変数名で変数参照

```bash
eval echo '$'$hoge
```


## 大文字・小文字変換

```
## toUpperCase

```
tr a-z A-Z
tr '[:lower:]' '[:upper:]'
```

## toLowerCase

```
tr A-Z a-z
tr '[:upper:]' '[:lower:]'
```
```

## 一行ずつ処理

```bash
cat file | while read line ; do
  #
done
```

## コマンド結果をファイル名引数に

```
diff <(cmd1) <(cmd2)
diff <(ssh host1 cat /etc/hosts) <(ssh host2 cat /etc/hosts)
```

## 特殊変数
### 最初の引数
`!^`
### 最後の引数
`!$`
### 指定の引数(n番目)
`!:n`
### すべての引数
`!*`

## 実行したコマンド自体を利用する
### 直前に実行したコマンド
`!!`
### コマンド履歴を検索して、最初にヒットしたコマンド
`!hoge`
### 直前に実行したコマンドのfooをbarにして実行
`!:s/foo/bar`

## パスを利用する
### 拡張子を除いたパスを取得
`!$:r`
### 拡張子だけを取得
`!$:e`
### パスのディレクトリ部分を取得
`!^:h`
### ファイル名だけを取得
`!^:t`

## スクリプトで使用する特殊変数

- `$?` 	直前に実行されたコマンドの終了ステータスが設定される変数。
- `$!` 	バックグラウンドで実行されたコマンドのプロセスID が設定される変数。
- `$-` 	set コマンドで設定されたフラグ、もしくはシェルの起動時に指定されたフラグの一覧が設定される変数。
- `$$` 	コマンド自身の PID (プロセスID)が設定される変数。シェルスクリプト内の場合はシェルスクリプトのPIDが取得できる。
- `$#` 	実行時に指定された引数の数が設定される変数。
- `$@` 	シェルスクリプト実行時、もしくは set コマンド実行時に指定された全パラメータが設定される変数。`$*` と基本的に同じだが""で囲んだときの動作が異なる。
- `$*` 	シェルスクリプト実行時、もしくは set コマンド実行時に指定された全パラメータが設定される変数。`$@` と基本的に同じだが""で囲んだときの動作が異なる。
- `$LINENO` 	この変数を使用している行の行番号が設定される変数。
- `${PIPESTATUS[@]}` 	パイプで連結した各コマンドの終了ステータスが設定される変数(配列)。パイプ(「|」)により連結された各コマンドの終了ステータスが設定設定されている変数(配列)。

## if

| expr                   | 意味                    |                       |     |
| ---------------------- | --------------------- | --------------------- | --- |
| num1 -eq num2                | num1とnum2が等しければ true        | equal                 | =   |
| num1 -ne num2                | num1とnum2が等しくなければ true      | not equal             | !=  |
| num1 -gt num2                | num1がnum2より大なら true         | greater than          | >   |
| num1 -ge num2                | num1がnum2以上なら true          | greater than or equal | >=  |
| num1 -lt num2                | num1がnum2より小なら true         | less than             | <   |
| num1 -le num2                | num1がnum2以下なら true          | less than or equal    | <=  |
| str = str2                  | strとstr2が等しければ true        |                       |     |
| str != str2                 | strとstr2が等しくなければ true      |                       |     |
| -z str                   | strの文字列長が 0 なら true     |                       |     |
| -n str                   | strの文字列長が 0 より大なら true  |                       |     |
| -f file                   | fileがファイルなら true         |                       |     |
| -d file                   | fileがディレクトリなら true       |                       |     |
| -e file                   | fileが存在するなら true         |                       |     |
| -s file                   | fileのサイズが 0 より大きければ true |                       |     |
| -r file                   | fileが読み取り可能なら true       |                       |     |
| -w file                   | fileが書き込み可能なら true       |                       |     |
| -x file                   | fileが実行可能なら true         |                       |     |
| -L file<br>-h file | fileがシンボリックリンクなら true     |                       |     |

## Exit code
| code    | 意味                               | 例                       | 備考                                                                                                                                                                               |
| ------- | -------------------------------- | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `1`     | 一般的なエラー全般                        | `$ let "var 1 = 1 / 0"` | ゼロ除算などのコマンドを継続できない雑多なエラー                                                                                                                                                         |
| `2`     | （Bash のドキュメントによると）シェルビルトインな機能の誤用 | `$ empty_function(){}`  | [キーワードのつけ忘れ](http://tldp.org/LDP/abs/html/debugging.html#MISSINGKEYWORD) やコマンド，または権限周りの問題（あと，[`diff` がバイナリファイルの比較に失敗した時](http://tldp.org/LDP/abs/html/filearchiv.html#DIFFERR2)） |
| `126`   | 呼び出したコマンドが実行できなかった時              | `$ /dev/null`           | パーミッションの問題かコマンドが executable でない時                                                                                                                                                 |
| `127`   | コマンドが見つからない時                     | `$ illegal_command`     | `$PATH` がおかしい時や typo した時などに起こる                                                                                                                                                   |
| `128`   | `exit` コマンドに不正な引数を渡した時           | `$ exit 3.14159`        | `exit` コマンドは 0〜255 の整数だけを引数に取る                                                                                                                                                   |
| `128+n` | シグナル `n` で致命的なエラー                | `$ kill -9 $PPID`       | 例では， `$?` は 137（128 + 9）を返す                                                                                                                                                      |
| `130`   | スクリプトが Ctrl+C で終了                | Ctrl+C                  | Ctrl+C はシグナル2で終了する = 128 + 2 = 130（上記）                                                                                                                                           |
| `255`   | 範囲外の exit status                 | `$ exit -1`             | `exit` コマンドは 0〜255 の整数だけを引数に取る                                                                                                                                                   |

