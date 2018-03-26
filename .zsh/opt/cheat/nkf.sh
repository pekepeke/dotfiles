# 文字コード判別
nkf -g file
# sjis -> utf8
nkf -S -w file
# utf8 -> sjis
nkf -W -s file

# BOMの付加・除去 // http://takuya-1st.hatenablog.jp/entry/2018/03/21/020120
nkf --overwrite --oc=UTF-8-BOM src.csv
nkf --overwrite --oc=UTF-8 src.csv

# フォルダ内の txt ファイルの文字コードを表示する
ls  **/*.txt | xargs -I@ nkf -w -g @
# まとめてUTF-8にする
ls  **/*.txt | xargs -I@ nkf -w --overwrite @

# メールのタイトルをデコード
echo  'Subject: [kof2011pc:00187] =?ISO-2022-JP?B?GyRCNGsyaCVWITwlOUpnGyhC?==?ISO-2022-JP?B?GyRCPTgkTjlwQ04lYSE8GyhC?==?ISO-2022-JP?B?GyRCJWsbKEI=?=' | nkf -w -
# タイトルエンコード
echo これはテスト | nkf -jM

# URIデコード
echo %E3%81%93%E3%82%93%E3%81%AB%E3%81%A1%E3%81%AF%EF%BC%81 | nkf --url-input
# CP932のURIデコード(-w →出力をUTF8に)
echo %82%B1%82%F1%82%C9%82%BF%82%CD | nkf -w  --url-input

# URIエンコード
iecho こんにちは！ | nkf -MQ | sed s/=/%/g

