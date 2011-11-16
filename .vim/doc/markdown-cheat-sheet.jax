*markdown-cheat-sheet.jax*	Markdown カンニングペーパー

    作者:       Kyo Nagashima <kyo@hail2u.net>
    バージョン: 0.04
    説明:       Markdown 記法のカンニングペーパーです。

1. 記法の例		|markdown-cheat-sheet-examples|
   1.1 段落		   |markdown-cheat-sheet-paragraph|
   1.2 改行		   |markdown-cheat-sheet-linebreak|
   1.3 テキストの強調	   |markdown-cheat-sheet-emphasis|
   1.4 コード		   |markdown-cheat-sheet-code|
   1.5 リスト		   |markdown-cheat-sheet-lists|
   1.6 見出し		   |markdown-cheat-sheet-headings|
   1.7 引用		   |markdown-cheat-sheet-blockquotes|
   1.8 リンク		   |markdown-cheat-sheet-links|
   1.9 画像		   |markdown-cheat-sheet-images|
   1.10 水平線		   |markdown-cheat-sheet-hr|
2. 履歴			|markdown-cheat-sheet-history|
3. About		|markdown-cheat-sheet-about|


==============================================================================
1. 基本                                           *markdown-cheat-sheet-basic*

以下の例は Markdown の記法の包括的なリストではないし、1 つの効果を実現するため
に複数の記法が利用できる場合も多い。詳細は full Markdown syntax を参照せよ:

http://daringfireball.net/projects/markdown/syntax

Markdown が書式化コマンドとして解釈する文字は、バックスラッシュを加えることに
よって、その文字そのものとして解釈させることができる。例えば '\*' は、テキスト
強調の開始ではなくアスタリスクとして出力される。 また「生」の XHTML のブロック
レベル要素の中にあるテキストに対して Markdown はいかなる変換も行わないので、
XHTML のブロックレベル要素のタグでテキストを囲むことによって、Markdown のソー
ス文章の中に XHTML のセクションを加えることもできる。


1.1 段落                                      *markdown-cheat-sheet-paragraph*

段落は 1 つ以上の連続したテキストであり、空行によって分けられる。通常の段落を
スペースやタブでインデントしてはならない: >
	これは段落です。2つの文があります。
	
	これは別の段落です。ここにも2つの文があります。
<


1.2 改行                                      *markdown-cheat-sheet-linebreak*

テキストに挿入された改行は最終的な結果から取り除かれる。画面の大きさに応じて改
行を行う処理は Web ブラウザが担当するのである。強制的に改行したい場合は、行末
に 2 つのスペースを挿入すればよい。


1.3 テキストの強調                             *markdown-cheat-sheet-emphasis*

>
	*強調 したい 部分* （つまり、イタリック体）

	**強く 強調 したい 部分** （つまり、太字）
<


1.4 コード                                         *markdown-cheat-sheet-code*

コード（等幅フォントで表示される）を挿入するには下記のいずれかを用いる:

1 行のコードにはバッククォートを使う: >
	`コード`
<

複数行のコードでは 4 文字以上の半角空白でインデントする: >
	    コード 1 行目
	    コード 2 行目
	    コード 3 行目
<


1.5 リスト                                        *markdown-cheat-sheet-lists*

>
	* 順序無しリストのアイテム
	* 順序無しリストの別のアイテム
	* 順序無しリストのさらに別のアイテム

	1. 順序付きリストのアイテム
	2. 順序付きリストの別のアイテム
	3. 順序付きリストのさらに別のアイテム
<


1.6 見出し                                     *markdown-cheat-sheet-headings*

HTML の見出しは、テキストの前にいくつかの '#' を置くことで作ることができる。
'#' の数が見出しのレベルに対応する（HTML は、見出しのレベルを 6 まで提供してい
る）。例を挙げる: >
	# レベル1の見出し

	#### レベル4の見出し
<

最初の 2 つのレベルには代替の記法が存在する: >
	レベル 1 の見出し
	=================

	レベル 2 の見出し
	-----------------
<


1.7 引用                                    *markdown-cheat-sheet-blockquotes*

>
	> このテキストは、HTMLのblockquote要素に囲まれます
<


1.8 リンク                                        *markdown-cheat-sheet-links*

>
	[リンクのテキスト](リンクのURL "リンクのタイトル")
<


1.9 画像                                         *markdown-cheat-sheet-images*

>
	![代替テキスト](画像のURL "画像のタイトル")
<


1.10 水平線                                          *markdown-cheat-sheet-hr*

1 行の中に、3 つ以上のハイフンやアスタリスク・アンダースコアだけを並べると水平
線が作られる。ハイフンやアスタリスクの間には空白を入れてもよい。以下の行はすべ
て水平線を生成する: >
	* * *
	***
	*****
	- - -
	---------------------------------------
<


==============================================================================
2. 履歴                                         *markdown-cheat-sheet-history*

0.05    強調がヘルプタグになってしまいヘル機能が壊れるバグを修正

0.04    細かい修正

0.03    細かい修正

0.02    キーワードの prefix を統一

0.01    initial release


==============================================================================
3. About                                          *markdown-cheat-sheet-about*

このカンニングペーパーはウィキペディアの Markdown 記事に基づいたものです。従っ
てこのテキストもクリエイティブ・コモンズ 表示-継承ライセンスの下で利用可能です。
ライセンスについての詳細は以下の URL を参照してください:

http://creativecommons.org/licenses/by-sa/3.0/


==============================================================================

 vim:tw=78:ts=8:ft=help:norl:
