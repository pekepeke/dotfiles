#!/usr/bin/env perl

# %%%{CotEditorXInput=AllText}%%%
# %%%{CotEditorXOutput=ReplaceAllText}%%%
use strict;
use warnings;

while(<>) {
    $_ =~ s!^[\+\-\r\n]+$!!g;
    $_ =~ s!^\| *!!g;
    $_ =~ s! +\| +!\t!g;
    $_ =~ s! +\|$!!;
	print if $_;
}
