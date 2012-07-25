#!/usr/bin/php
<?php
// %%%{CotEditorXInput=Selection}%%%
// %%%{CotEditorXOutput=ReplaceSelection}%%%
$handle = fopen("php://stdin", "r");
$res = "<table>\n";
while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
    $res .= "<tr>";
    $res .= "<td>" . implode("</td><td>",$data) . "</td>";
    $res .= "</tr>\n";
}
$res .= "</table>\n";
fclose($handle);
echo $res;
