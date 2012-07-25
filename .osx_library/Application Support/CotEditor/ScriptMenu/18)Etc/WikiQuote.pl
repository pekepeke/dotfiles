#!/usr/bin/env perl
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%
use strict;
use warnings;
use encoding ‘utf8′; # perl の内部コードに変換(UTF-8 フラグを付ける)
binmode(STDERR, ‘:raw :encoding(utf8)’);

my $insertathead = “> “;

# STDIN を 1 行ずつ処理
while (<>) {
print $insertathead,$_;
}