#!/usr/bin/php
<?php
// isert <radialGradient> tags for <defs> section
//
//                         by 1024jp 2012-02-25
//
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%

echo <<< END_OF_TEMPLATE
	<radialGradient id="RadialGradient" fx="50%" fy="50%">
		<stop offset="0" stop-color="hsl(0,0%,  0%)"/>
		<stop offset="1" stop-color="hsl(0,0%,100%)"/>
	</radialGradient>
END_OF_TEMPLATE;
