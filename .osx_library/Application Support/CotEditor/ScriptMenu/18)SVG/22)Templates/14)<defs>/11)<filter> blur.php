#!/usr/bin/php
<?php
// isert blur filter tags for <defs> section
//
//                         by 1024jp 2012-02-25
//
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%

echo <<< END_OF_TEMPLATE
	<filter id="Blur">
		<feGaussianBlur stdDeviation="3"/>
	</filter>
END_OF_TEMPLATE;
