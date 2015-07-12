#!/usr/bin/env perl

use strict;
use DBI;
use Encode;
use SQL::Translator;
use Data::Dumper;

my $CONV_HTML_CHARSET_ORG = 'content="text/html; charset=iso-8859-1"';
my $CONV_HTML_CHARSET_NEW = 'content="text/html; charset=utf8"';

main();

sub main {

    my $tr = SQL::Translator->new();
    #対象のdbms
    $tr->parser("SQL::Translator::Parser::MySQL");

    #parse結果の出力形式
    $tr->producer("SQL::Translator::Producer::HTML");
#    $tr->producer("SQL::Translator::Producer::YAML");
    my $ddl = "";

    for my $fpath (@ARGV) {
        print $fpath;
        open my $fp, '<', $fpath or die "$fpath: $!";
        my @lines = <$fp>;
        close($fp);
        $ddl .= join("\n", @lines);
    }
    $tr->parser->($tr, $ddl);
    my $output = $tr->producer->($tr);
    $output =~ s/\\n/<br>/o;
    $output =~ s/$CONV_HTML_CHARSET_ORG/$CONV_HTML_CHARSET_NEW/o;

    print $output;
}


