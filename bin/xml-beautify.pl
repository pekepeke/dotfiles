#!/usr/bin/env perl

use XML::Beautify qw(:const);

local $/;
$xml_src = <STDIN>;
$xml = XML::Beautify->new();
$pretty_xml = $xml->beautify(\$xml_src);

print $pretty_xml . "\n"
