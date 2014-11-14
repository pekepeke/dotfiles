%a	アクセス元のIPアドレス
%A	サーバ(Apache)のIPアドレス
%B	送信されたバイト数(ヘッダーは含まず)
%b	送信されたバイト数(ヘッダーは含まず)。0バイトの時は「-｣
%f	リクエストされたファイル名
%h	リモートホスト名
%H	リクエストのプロトコル名
%l	クライアントの識別子
%m	リクエストのメソッド名
%q	リクエストに含まれるクエリー文字列。空白以外は「?」が付く。
%r	リクエストの最初の行の値
%s	レスポンスステータス
%>S	最後のレスポンスのステータス
%t	時刻
%D 	リクエストを処理するのにかかった時間、マイクロ秒単位
%T	処理にかかった時間
%u	認証ユーザー名
%U	リクエストのURLパス
%v	リクエストに対するバーチャルホスト名
%V	UseCanonicalNameによるサーバ名
%X	接続ステータス
%{クッキー名}C	リクエストに含まれるクッキーの値
%{環境変数名}e	環境変数名の値
%{ヘッダー名}i	リクエストに含まれるヘッダー名の値
%{ヘッダー名}o	レスポンスに含まれるヘッダー名の値
%{メモ}n	モジュールから渡されるメモの値
%{フォーマット}t	フォーマットされた時刻
