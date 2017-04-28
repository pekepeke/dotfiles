### build

#### debian

```
sudo apt-get build-dep vim
sudo apt-get install gettext libncurses5-dev libacl1-dev libgpm-dev
sudo apt-get install libperl-dev python-dev python3-dev ruby-dev
sudo apt-get install lua5.2 liblua5.2-dev
sudo apt-get install luajit libluajit-5.1
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

