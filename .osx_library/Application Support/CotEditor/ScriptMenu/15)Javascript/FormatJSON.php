#!/usr/bin/php
<?php
// %%%{CotEditorXInput=AllText}%%%
// %%%{CotEditorXOutput=ReplaceAllText}%%%
$text = file_get_contents('php://stdin');
$text = json_decode($text);
print_r($text);
?>