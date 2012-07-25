#!/usr/bin/php
<?php
// isert glayscale filter tags for <defs> section
//
//                         by 1024jp 2012-02-25
//
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%

echo <<< END_OF_TEMPLATE
	<filter id="Grayscale">
		<feColorMatrix values="0.333 0.333 0.333 0 0
		                       0.333 0.333 0.333 0 0
		                       0.333 0.333 0.333 0 0
		                       0     0     0     1 0"/>
	</filter>
END_OF_TEMPLATE;
