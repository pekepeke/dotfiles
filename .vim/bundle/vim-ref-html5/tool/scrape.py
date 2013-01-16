#!/usr/bin/python
# -*- coding: utf-8 -*-

#
# HTML5jpのHTMLタグリファレンスに対して<article>を
# スクレイピングするためのスクリプト。
# BeautifulSoup依存
#

import urllib2
import os
import shutil
from BeautifulSoup import BeautifulSoup

# 以下のディレクトリ以下の.htmlファイルをスクレイピング対象とする
# 再帰検索は行わない
path = "www.html5.jp/tag/elements"
# スクレイピング後の出力ファイル
dist_dir = "./dist"
# 出力時にラップされるHTMLテンプレート
html_raw = """
<!DOCTYPE html>
<html lang="ja">
    <head>
    </head>
    <body>
    <body
</html>
"""

def main():
    if path == None or len(path) == 0:
        # TODO 例外を投げる
        pass

    if (os.path.exists(dist_dir)):
        shutil.rmtree(dist_dir)
    os.mkdir(dist_dir)
    files = []
    if (os.path.isdir(path)):
        files = [x for x in os.listdir(path) if x.endswith('.html')]
    # else:
    #    files.append(path)

    for f in files:
        fpath = os.path.join(path, f)
        with open(fpath, "r") as in_path:
            print "=" * 5 + " " + f + "=" * 5
            soup = BeautifulSoup(in_path)
            if f.endswith("index.html"):
                print "\t this page is index."
                html = soup
            else:
                article = soup.find("article")

                html = BeautifulSoup(html_raw)
                head = html.find("head")

                for x in reversed(soup.findAll("meta")):
                    head.insert(0, x)

                head.insert(1, soup.find("title"))
                html.find("body").insert(1, article)
                print html

            # output
            with open(dist_dir + "/" + f, "w") as out_path:
                out_path.write(html.prettify())

if __name__ == "__main__":
    main()
