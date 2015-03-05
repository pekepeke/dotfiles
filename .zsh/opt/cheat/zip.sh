# ディレクトリ内を再帰的に圧縮
zip -r file.zip dir/
# パスワード付きで圧縮
zip -e file.zip filename
# stored 圧縮
zip -0 file.zip filename
# fetch & unzip
unzip =(curl -L http://path/to.zip)
