#!/bin/sh
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%

INPUT=`cat -`
TEMP=$(mktemp tmp.XXXXXX)
echo "${INPUT}" >> $TEMP
# /usr/local/bin/atyle
# http://astyle.sourceforge.net/astyle.html
OUTPUT=$(/usr/local/bin/astyle -s2 < $TEMP)
rm $TEMP
echo "${OUTPUT}"
