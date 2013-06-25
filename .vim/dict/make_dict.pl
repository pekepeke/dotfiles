#!/usr/bin/env perl

while(<DATA>){
    chomp; my $command = (split)[0];
    print $command."\n" if $command =~ /^\w\w+$/;
}
print join("\n", qw/for while until foreach if elsif else unless/) . "\n";

# perl preldic.pl | sort > ~/.vim/dict/perl_function.dict
# http://cpansearch.perl.org/src/NWCLARK/perl-5.8.8/lib/Pod/Functions.pm
__DATA__
