#!/usr/bin/php
<?php
// insert SVG 1.0 DTD
//
//                         by 1024jp 2011
//
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%

echo <<< END_OF_TEMPLATE
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd" [
	<!ATTLIST svg xmlns:xlink CDATA #FIXED "http://www.w3.org/1999/xlink">
]>
END_OF_TEMPLATE;
