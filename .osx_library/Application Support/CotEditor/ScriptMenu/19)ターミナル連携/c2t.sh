#! /bin/bash
VERSION=1.1
# 参考：http://shellscript.sunone.me/parameter.html

# 使用例
# c2t | sort -u | t2c

# 与えられたオプションを確認する
OPTCOUNT=0;
while getopts adsh OPT
do
  case $OPT in
    "a" ) FLG_A="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
    "d" ) FLG_D="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
    "s" ) FLG_S="TRUE" ; OPTCOUNT=`expr $OPTCOUNT + 1` ;;
    "h" ) FLG_H="TRUE" ; OPTCOUNT=1 ;;
    * )   FLG_H="TRUE" ; OPTCOUNT=1 ;;
  esac
done

# オプションが与えられたかどうか確認する
if [ $OPTCOUNT -eq 0 ]; then
    # オプションなしなら -s と同等
    FLG_S="TRUE"
    OPTCOUNT=`expr $OPTCOUNT + 1`
fi

# オプションの排他
if [ $OPTCOUNT -ne "1" ]; then
    echo 'Usage: -a or -b or -s' 1>&2
    exit 1
fi

# ヘルプ
if [ "$FLG_H" = "TRUE" ]; then
    echo "c2t (CotEditor to Terminal ver$VERSION)"
    echo "-d Echo text of front Document."
    echo "-s Echo text of Selection. (Default)"
    echo "-h Show Help."
    exit 0
fi

# オプションごとの処理を行う

# 選択範囲
if [ "$FLG_S" = "TRUE" ]; then
    RET=`osascript <<EOF
        tell application "CotEditor"
            if (exists front document) then
                return contents of selection of front document
            end if
        end tell
EOF
`
fi

# ドキュメント全体
if [ "$FLG_D" = "TRUE" ]; then
    RET=`osascript <<EOF
        tell application "CotEditor"
            if (exists front document) then
                return contents of front document
            end if
        end tell
EOF
`
fi

echo "$RET"

exit
