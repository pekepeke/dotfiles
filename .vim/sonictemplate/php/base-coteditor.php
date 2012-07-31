#!/usr/bin/php
<?php
// %%%{CotEditorXInput=Selection}%%%
// %%%{CotEditorXOutput=ReplaceSelection}%%%

$stdin = file_get_contents("php://stdin");
$stdout = '/*' . $stdin . '*/';
echo $stdout;

