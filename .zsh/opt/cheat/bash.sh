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

## 置換
- {変数名#パターン} → 前方一致でのマッチ部分削除(最短マッチ)
- ${変数名##パターン} → 前方一致でのマッチ部分削除(最長マッチ)
- ${変数名%パターン} → 後方一致でのマッチ部分削除(最短マッチ)
- ${変数名%%パターン} → 後方一致でのマッチ部分削除(最長マッチ)
- ${変数名/置換前文字列/置換後文字列} → 文字列置換(最初にマッチしたもののみ)
- ${変数名//置換前文字列/置換後文字列} → 文字列置換(マッチしたものすべて)

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
