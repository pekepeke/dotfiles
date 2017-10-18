### gitbook
epub 作成ツール

```
npm -g i gitbook-cli

gitbook init   # プロジェクト作成
echo '{"plugins": ["mermaid-gb3", "plantuml"]}' > book.json
gitbook install
gitbook server # サーバー起動
# html 出力
gitbook html
# epub で出力する場合、calibre が必要
# sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | sudo python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"
gitbook [pdf/epub/mobi]
```

### textlint
文章校正ツール

```
npm i -g textlint
npm i -g textlint-rule-max-ten textlint-rule-spellcheck-tech-word textlint-rule-no-mix-dearu-desumasu

textlint --rule no-mix-dearu-desumasu --rule max-ten --rule spellcheck-tech-word README.md
# .textlintrc ファイルを作成すればオプション不要
textlint README.md
```

- 参考記事
	- http://efcl.info/2015/09/10/introduce-textlint/
	- http://efcl.info/2015/12/30/textlint-preset/
	- http://efcl.info/2015/10/19/textlint-plugin-JTF-style/
	- http://efcl.info/2015/09/14/textlint-rule-prh/
- starter kit
	- https://github.com/kubosho/textlint-starter-kit

