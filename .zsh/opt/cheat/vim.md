### build

#### Terminal
| キー        | 機能                            |
|-------------|---------------------------------|
| C-w C-w     | 次のウィンドウへ遷移            |
| C-w :       | Exコマンドを使う                |
| C-w .       | C-wをターミナルに送信           |
| C-w C-\     | C-\をターミナルに送信           |
| C-w n       | Normalモードに遷移              |
| C-\ C-n     | Normalモードに遷移              |
| C-w " {reg} | {reg}レジスターの内容をペースト |
| C-w C-c     | ジョブを終了させる              |

#### debian

```
sudo apt-get build-dep vim
sudo apt-get install -y gettext libncurses5-dev libacl1-dev libgpm-dev libperl-dev python-dev python3-dev ruby-dev lua5.2 liblua5.2-dev luajit libluajit-5.1
# gvim
sudo apt-get install libxmu-dev libgnomeui-dev libxpm-dev
# gui-unity
sudo apt-get install libgtk2.0-dev
# gui-gnome
sudo apt-get install libgnomeui-dev
```

### multiline match

```
\_.      <= 最長マッチ
\_.\{-}  <= 最短マッチ
" HTML コメント全削除
%s@<!--\_.\{-}-->@@g
```

### global

```
" ヒットした行削除
:g/[word]/d
" ヒットしない行削除
:v/[word]/d
" ヒットする行の前後を確認する場合
:g//z#.5|echo '----'
" ファイル末尾に移動
:g/[word]/m$
" ヒットした行を結合
:g/[word]/,/<C-r>//j 
" yyp
:g/[word]/norm!yyp
```

### \zs, \zero

```
%s/\zsBar\zeSecond/Foo/g
```

### very magic

```
/\v^a
%s!\v^aa!fuga!
```

### expand

```
:p ファイル名の完全パス
:~ ファイル名のホームディレクトリからの相対的なパス
:. ファイル名のカレントディレクトリからの相対的なパス
:h ファイル名のディレクトリ名部分のパス(head)
:t ファイル名のファイル名部分のパス(tail)
:r ファイル名の最後の拡張子を除いたもの(root)
:e ファイル名の拡張子（存在する場合）(extension)
:s?pat?sub? ファイル名の最初に一致した pat を sub に置き換えたもの
:gs?pat?sub? ファイル名の pat に一致した全てを sub に置き換えたもの
```

### keymap memo

- `C-^` - 直前のバッファに戻る

