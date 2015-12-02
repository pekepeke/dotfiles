## よく忘れる
### マークの意味

```
M dot.cshrc            : ワークスペースで編集中 (Modified)
U benkyo7.mgp          : 更新 (Updated)、または追加された
P benkyo7.html         : pserver 利用での更新 (Pserver)
A dot.emacs            : 時間 commit 時に追加される (Added)
R ascii.log            : 次回 commit 時に削除される (Removed) 
? verbose.log          : リポジトリに含まれていない

U	最新状態(Up to date)に更新された
P	Patchが当てられた(結果は U と同じ)
M	修正(Modify)された
A	追加(Add)された(必要なら commit すべき)
R	削除(Remove)された
C	衝突(Conflict)が起きている
?	リポジトリにないファイル
```

### 簡易集計

```
awk 'length($1) == 1 {sum[$1]+=1}; END { for (key in sum) { print key,  sum[key] } }' fuga.log
```

### cvs2cl.pl
```
cvs2cl.pl -b -t --stdout [file]
cvs2cl.pl --stdout [file]
```

### 特定リビジョンのファイル内容の出力
```
cvs update -p -r リビジョン ファイル
```

### ローカル更新を無視する
```
cvs update -C -l filepath
```

## checkout
cvs checkout 〔-d 作業用ディレクトリ名〕 プロジェクト名
cvs co
cvs get

## update
```
cvs update [option] [file]
cvs up
cvs up -dP
```

-I ファイル   | 更新したくないファイルを指定。（通常は全ファイルが対象になるから）
-l            | 現在のディレクトリだけを対象とする。（サブディレクトリを再帰的にチェックしない）
-p            | ファイルの内容を（ファイルにではなく）標準出力に出力する。
-r リビジョン | そのリビジョンの内容を取り出す。stickyが付く。
-D 日付       | その日付時点で最新の内容を取り出す。stickyが付く。
-A            | 今のファイルに付いているstickyを解除する。
-C            | 作業ディレクトリでの修正を無視して、強制的にリポジトリの内容を取り出して上書きする。
-j タグ名     | ブランチ（やトランク）の修正をマージ（join）する。このオプションを２つ指定すると、その間の修正をマージする。
-kオプション  | 作業ディレクトリ上のファイルのkオプションを指定する。
-d            | リポジトリにディレクトリが追加されていたら、作業ディレクトリにもそれを追加する。（通常は、作業ディレクトリにあるディレクトリしかチェックされない）
-P            | リポジトリからディレクトリが削除されていたら、作業ディレクトリからも削除する。（通常は、作業ディレクトリにあるディレクトリは削除されない）

## commit

```
cvs commit [option]
cvs ci
```
-m'[message]' | [message]をログメッセージとして指定
-F file       | ファイル内容をログメッセージとする
-f            | 強制的にコミットする

## add

```
cvs add [file]
```

- サブディレクトリは再帰的に追加されないので、追加したい場合はサブディレクトリの下に移動して、再び add を行う必要がある。
- コミット前に追加をやめるには remove を使う
- バイナリとして追加したい場合は `-kb` オプションを指定する

## admin
ファイルの属性を変更する

```
cvs admin -b [file]
```

## diff

```
cvs diff file
cvs diff -c -r [rev]
cvs diff -r [rev] -r [rev] file
```

## log
```
cvs log [file]
```

