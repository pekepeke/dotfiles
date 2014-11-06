# 文字コード判別
nkf -g file
# sjis -> utf8
nkf -S -w file
# utf8 -> sjis
nkf -W -s file

