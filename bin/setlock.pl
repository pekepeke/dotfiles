#!/usr/bin/env perl

#  setlock.pl - perl replacement for djb's broken setlock executable
#  takes no options
#  Usage:  setlock.pl /path/to/lockfile $command @args

use strict;
use warnings FATAL => 'all';
use Fcntl ":flock";

my ($lockfile, $command, @args) = @ARGV;

die "Usage: $0 /path/to/lockfile command args"
    unless $lockfile and $command;

open my $fh, "+>", $lockfile or die "Can't open lockfile $lockfile: $!";
flock $fh, LOCK_EX | LOCK_NB or die "Can't get exclusive lock on $lockfile: $!";
exit system $command, @args;

