@rem = '--*-Perl-*--
@echo off
perl -x -S "%~f0" %*
goto :EOF
@rem ';
#!/usr/bin/perl

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

print "Hello World!";

# vim:ft=perl ff=dos fenc=cp932:
__END__

=head1 NAME

    <+FILENAME+> - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

<+AUTHOR+> <<+EMAIL+>>

