set FilePath to ""
set FileName to ""

tell application "CotEditor"
        set FilePath to path of document 0 as Unicode text
        set FileName to name of document 0 as Unicode text
        set isRun to modified of document 0 as boolean
        --保存してない場合はエラーで返す
        if isRun then
                display dialog "ファイルを保存して再度実行してください" buttons {"OK"} default button "OK" with icon stop
                return
        end if
end tell
--※※※ bash前提！ ※※※
display dialog (do shell script "cd " & "`dirname \"" & FilePath & "\"`;perl -wc " & FileName & " 2>&1") as Unicode text
