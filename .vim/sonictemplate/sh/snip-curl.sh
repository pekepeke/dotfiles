curl 'http://example.com/entries' \
-v
--get \
--data-urlencode 'q=word'


curl 'http://example.com/entries' \
-v \
--request POST \
--data-urlencode 'fuga=piyo'

curl 'http://example.com/entries' \
--verbose \
--request POST \
--header 'Content-Type: application/json' \
--data-binary '{"title":"hoge","description":"fuga"}'


 curl 'http://example.com/entries' \
--verbose \
--request POST \
--header 'Content-Type: application/json' \
--data-binary @file.json


curl 'http://packagist.jp/packages.json' \
--verbose \
--header 'DNT: 1'

