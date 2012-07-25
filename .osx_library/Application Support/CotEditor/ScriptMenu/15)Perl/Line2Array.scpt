(*
CotEditor用スクリプト
コーディングサポートシリーズ「固定文字リストの配列化」
2010/4/6 by hirakun
http://hirakun.blog57.fc2.com/
*)
tell application "CotEditor"
tell front document
--選択範囲を再度セットすることで行単位での選択にする
--選択範囲は最後に再セットするのでここで値を覚えておく
set SelectRange to line range of selection
set line range of selection to SelectRange

--選択範囲のコンテンツを取得
set SelectContents to contents of selection as Unicode text

--デリミタとして利用する改行文字を取得
set LineItem to line ending
if (LineItem = LF) then
set LineEnd to ASCII character (10)
else if (LineItem = CR) then
set LineEnd to ASCII character (13)
else if (LineItem = CRLF) then
set LineEnd to (ASCII character (13)) & (ASCII character (10))
end if

--デリミタで分解してリストを取得
set LastDelimit to AppleScript's text item delimiters --デリミタ復帰用に現在値を退避
set AppleScript's text item delimiters to LineEnd
set SelectList to every text item of SelectContents

--変数名を取得
display dialog "変数名を指定してください" default answer "" buttons {"キャンセル", "OK"} default button 2 with icon note
set ArrayName to text returned of result

--ループ数
set ListLength to count of SelectList
--配列ソース記述用のカウント（空行対応）
set ArrayCount to 0
repeat with i from 1 to (ListLength)
--文字列が存在すれば処理する
--if ((count of (text item (i) of SelectList)) > 0) then
if ((text item (i) of SelectList) ≠ "") then
set moto to text item (i) of SelectList
set text item (i) of SelectList to (ArrayName & "[" & ArrayCount & "] = '" & moto & "';")
set ArrayCount to ArrayCount + 1
end if
end repeat

--デリミタで結合してコンテンツに返す（選択範囲テキストの入れ替え）
set contents of selection to (SelectList as Unicode text)

--デリミタ復帰
set AppleScript's text item delimiters to LastDelimit

--文字列が増減すると選択範囲が変化するので選択範囲を再設定する
set line range of selection to SelectRange
end tell
end tell