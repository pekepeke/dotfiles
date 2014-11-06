# PlistBuddy read
PlistBuddy  -c "Print CFBundleShortVersionString"  /path/to/plilst
# PlistBuddy write
 -c "Set :CFBundleShortVersionString 1.0.0" /path/to/plilst
# by xpath
xpath App-Info.plist "/plist/dict/key[.='CFBundleVersion']/following-sibling::*[1]/text()"
python -c "from lxml.etree import parse; from sys import stdin; print '\n'.join(parse(stdin).xpath('/plist/dict/key[.=\"CFBundleVersion\"]/following-sibling::*[1]/text()'))"
