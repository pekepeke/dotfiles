#!/usr/bin/env perl

# %%%{CotEditorXInput=AllText}%%%
# %%%{CotEditorXOutput=ReplaceAllText}%%%
use strict;
use warnings;

my (@matrix, @tmp);
my $i = 0;
while(<>) {
    chomp;
    @tmp = split(/\t/, $_);
    for (0..$#tmp) { $matrix[$_][$i] = $tmp[$_]; }
    $i++;
}

print join("\n", map {
    sprintf("%s in (%s)", shift(@$_), join(", ", map { $_=~/^[0-9]*$/ ? $_ : "'".$_."'"} @$_));
} @matrix);

