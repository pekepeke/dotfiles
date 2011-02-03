#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

my $opt_help;
GetOptions(
    'h|help' => \$opt_help, 
) or usage;
usage if $opt_help;

__END__

=head1 NAME

    <+FILENAME+> - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

<+AUTHOR+> <<+EMAIL+>>
