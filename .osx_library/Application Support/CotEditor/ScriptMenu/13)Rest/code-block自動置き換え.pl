#!/usr/bin/perl
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%
use strict;
use warnings;
use encoding 'utf8';
binmode(STDERR, ':raw :encoding(utf8)');
my $insertathead = " ";
print " :: \n\n";
while (<>) {
print $insertathead,$_;
}
print "\n\n";