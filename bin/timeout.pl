#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;
use POSIX qw( SIGKILL );
# use Time::HiRes;# qw(usleep nanosleep);

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

my %opts;
Getopt::Long::Configure("bundling");
GetOptions(\%opts, qw(
    help|h=s
    timeout|t=f
)) or usage;

usage if $opts{help};
$opts{timeout} = 1 unless $opts{timeout};

my $ret = system_timeout($opts{timeout}, @ARGV);
if ($ret == -2) {
    warn "force killed : @ARGV\n";
    exit $ret;
}

sub system_timeout {
    my $timeout = shift;
    my $waitsec = 0.1;
    my @cmd = @_;
    my $pid = fork();

    # fail fork
    return -1 if !defined($pid);

    if ($pid == 0) {
        exec(@cmd);
        exit(255);
    }
    while ($timeout > 0) {
        my $ret = waitpid($pid,&POSIX::WNOHANG);
        if ($ret != 0){
            return $? / 256;
        }
        $timeout -= $waitsec;
        # sleep($waitsec);
        select(undef, undef, undef, $waitsec);
    }
    kill(SIGKILL,$pid);
    waitpid($pid,0);
    return -2;
}

__END__

=head1 NAME

    timeout.pl - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR


