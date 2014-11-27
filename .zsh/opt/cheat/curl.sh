if curl -fksL http://hoge.com > /dev/null ; then echo OK; else echo NG ; fi
# basic
curl -u user:pass http://hoge.com
curl --user user:pass http://hoge.com
# insecure
curl -k http://hoge.com
# webdav upload
curl --upload somefile https://example.com/foo/
# user agent
curl -A ua http://hoge.com
# POST
curl -F "name1=value1" -F "name2=value" -F "profile_icon=@path/to/file.png" -F "zip_file=@path/to/zipfile.zip" http://yourdomain/execute.script
# クッキーを送信
curl -b cookie.txt http://www.example.com/
# クッキーを保存
curl -c cookie.txt http://www.example.com/
# 連番をダウンロード
curl -O http://example.com/data[001-100].txt
# ファイル名を指定してダウンロード
curl -Lo file http://example.com/index.html
# proxy 指定
curl -x host:8080 http://example.com/
# exit code 有効化
curl -f http://example.com
