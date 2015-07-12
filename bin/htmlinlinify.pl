#!/usr/bin/env perl

use Encode;
use CSS::Inliner;

my $inliner = new CSS::Inliner();
$inliner->read_file({ filename => $ARGV[0], charset => 'utf8'});
print encode_utf8($inliner->inlinify());
