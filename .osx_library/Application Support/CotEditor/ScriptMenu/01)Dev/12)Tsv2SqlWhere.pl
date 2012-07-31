#!/usr/bin/env perl

# %%%{CotEditorXInput=AllText}%%%
# %%%{CotEditorXOutput=ReplaceAllText}%%%
use strict;
use warnings;

my (@head, $i);
while(<>) {
    chomp;
    unless (@head) {
        @head = split(/\t/, $_);
    } else {
        $i = 0;
        print join(" AND ", map { sprintf("%s = %s", $head[$i++], $_ =~ /^[0-9]*$/ ? $_ : "'" . $_ . "'") } split(/\t/, $_)) . "\n";
    }
}
