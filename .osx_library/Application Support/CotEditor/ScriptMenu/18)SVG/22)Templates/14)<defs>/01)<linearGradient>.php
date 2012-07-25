#!/usr/bin/php
<?php
// isert <linearGradient> tags for <defs> section
//
//                         by 1024jp 2012-02-25
//
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%

echo <<< END_OF_TEMPLATE
	<linearGradient id="Gradient" x1="0" y1="0" x2="100%" y2="0">
		<stop offset="0" stop-color="hsl(0,0%,  0%)"/>
		<stop offset="1" stop-color="hsl(0,0%,100%)"/>
	</linearGradient>
END_OF_TEMPLATE;
