#!/usr/bin/php
<?php
// isert dropshadow filter tags for <defs> section
//
//                         by 1024jp 2012-02-25
//
// %%%{CotEditorXInput=None}%%%
// %%%{CotEditorXOutput=InsertAfterSelection}%%%

echo <<< END_OF_TEMPLATE
	<filter id="Dropshadow">
		<!-- [parameter] blur: stdDeviation / opacity: slope / offset: dx,dy -->
		<feGaussianBlur result="shadow" stdDeviation="1.5" in="SourceAlpha"/>
		<feComponentTransfer result="shadow">
  			<feFuncA type="linear" slope="0.25" />
		</feComponentTransfer> 
		<feOffset result="shadow" dx="2" dy="2"/>
		<feMerge>
			<feMergeNode in="shadow" opacity="0.1"/>
			<feMergeNode in="SourceGraphic"/>
		</feMerge>
	</filter>
END_OF_TEMPLATE;
