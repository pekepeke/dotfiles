#!/usr/bin/python
#
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%

import sys
from htmlentitydefs import codepoint2name

preText = unicode(sys.stdin.read(), "utf-8")
postText = ""
for c in preText:
    try:
        postText += '&%s;' % codepoint2name[ord(c)]
    except:
        postText += c
sys.stdout.write(postText.encode("utf-8"))
