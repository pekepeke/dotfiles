#!/usr/bin/env perl

use strict;
use warnings;
# use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

use DBI;
use Text::CSV;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

my %options = (
    type => 'mysql',
    port => 3306,
    host => "localhost",
    user => "root",
    password => "",
    database => "test",
    encoding => "utf8",
    csvencoding => 'cp932',
);
Getopt::Long::Configure ("bundling");
GetOptions(
    \%options,
    'verbose',
    'help',
    'port|p=i',
    'host|h=s',
    'user|u=s',
    'password=s',
    'database|d=s',
    'encoding|e=s',
    'csvencoding|c=s',
) or usage;

usage if $options{help};

my $dsn = "DBI:$options{type}:database=$options{database};host=$options{host};port=$options{port}";
my $dbh_opt = {
    # AutoCommit => 0,
    AutoCommit => 1,
    RaiseError => 1,
};
if ($options{type} eq "mysql") {
    $dbh_opt->{mysql_enable_utf8} = 1 if ($options{encoding} eq "utf8");
    $dbh_opt->{on_connect_do} = [
        qq[set names '$options{encoding}'],
        qq[set character set '$options{encoding}'],
    ];
}

# eval {
#     require "DBI::$options{type}";
# };
# if ($@) {
#     die "$@";
# }

my $dbh = DBI->connect(
    $dsn, $options{user}, $options{password}, $dbh_opt
) or die $DBI::errstr;

my $ctime = time;
for my $table (@ARGV) {
    my $sql = qq[
        select * from $table
    ];
    my $sth = $dbh->prepare($sql) or die $dbh->errstr;
    $sth->execute or die $sth->errstr;

    my @header = ();
    my @rows = ();
    push @header, $_ for @{$sth->{NAME}};

    push @rows, \@header;
    while (my $r = $sth->fetchrow_arrayref) {
        my @line = ();
        push @line, $_ for @{$r};
        push @rows, \@line;
    }
    $sth->finish();

    my $csv;
    $csv = Text::CSV->new({binary => 1});
    $csv->eol("\r\n");

    my $fname = "${table}-${ctime}.csv";
    open my $fh, ">:encoding($options{csvencoding})", $fname or die "$fname: $!";
    $csv->print($fh, $_) for @rows;
    close $fh or die "$fname: $!";
}
$dbh->disconnect;

__END__

=head1 NAME

    table2csv.pl - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

pekepeke <pekepekesamurai+github@gmail.com>
