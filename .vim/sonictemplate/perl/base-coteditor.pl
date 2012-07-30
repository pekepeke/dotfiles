#!/usr/bin/env perl

# %%%{CotEditorXInput=AllText}%%%
# %%%{CotEditorXOutput=ReplaceAllText}%%%
use strict;
use warnings;

while(<>) {
    $_ =~ s!abcde!abcde!gi;
	print if $_;
}
