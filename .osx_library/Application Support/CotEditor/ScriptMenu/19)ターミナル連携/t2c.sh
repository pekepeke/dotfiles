#! /bin/bash
VERSION=1.1
# 使用例
# ls -l | t2c

# 与えられたオプションを確認する
OPTCOUNT=0;
while getopts nsh OPT
do
  case $OPT in
    "n" ) FLG_N="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
    "s" ) FLG_S="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
    "h" ) FLG_H="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
    * )   FLG_H="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
  esac
done

# オプションが与えられたかどうか確認する
if [ $OPTCOUNT -eq 0 ]; then
    # オプションなしなら -s と同等
    FLG_S="TRUE"
    OPTCOUNT=`expr $OPTCOUNT + 1`
fi

# ヘルプ
if [ "$FLG_H" = "TRUE" ]; then
    echo "t2c (Terminal to CotEditor ver$VERSION)"
    echo "-s Insert text to Selection. (Default)"
    echo "-n Insert text to New document."
    echo "-h Show Help."
    exit 0
fi

# オプションごとの処理を行う

cat - > /tmp/t2c_temp_file

# 選択範囲に挿入を行う
if [ "$FLG_S" = "TRUE" ]; then
    osascript <<EOF
        tell application "CotEditor"
        if (exists front document) then
            set ret to do shell script "cat /tmp/t2c_temp_file"
            set contents of selection of front document to ret
        end if
        end tell
EOF
fi

# 新しいドキュメントに挿入を行う
if [ "$FLG_N" = "TRUE" ]; then
    osascript <<EOF
        tell application "CotEditor"
        make new document
        set ret to do shell script "cat /tmp/t2c_temp_file"
        set contents of selection of front document to ret
        end tell
EOF
fi

exit

