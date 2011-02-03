#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use LWP::Simple;
use JSON qw/encode_json decode_json/;
use File::Slurp;

my %fetch = (
    # not exists.... --;;
    # tidesktop => 'http://developer.appcelerator.com/apidoc/desktop/1.1.0/api.json', 
    timobile => 'http://developer.appcelerator.com/apidoc/mobile/1.5.1/api.json',
);
for my $name (keys %fetch) {
    my $url = $fetch{$name};

    my $json = format_json(get($url));
    write_file("$name.txt", $json);
}

sub format_json {
    my $json = shift;
    my $datas = decode_json($json);
    my @msgs = ();
    for my $k (keys %{$datas}) {
        push @msgs, $k;
        for my $m (@{$datas->{$k}->{methods}}) {
            push @msgs, "$k.$m->{name}(";
        }
        for my $p (@{$datas->{$k}->{properties}}) {
            push @msgs, "$k.$p->{name}";
        }
    }
    return join("\n", @msgs);
}

