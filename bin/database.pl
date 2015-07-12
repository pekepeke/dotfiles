#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;
use DBI;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

my %opts = (
    type => "mysql",
    user => "root",
    password => "",
);
Getopt::Long::Configure("bundling");
GetOptions(\%opts, qw(
    help|h
    type|t=s
    port|P=s
    host|h=s
    user|u=s
    password|p=s
)) or usage;
usage if $opts{help};


for my $database (@ARGV) {
    my @dsns = ();
    push @dsns, $database if $database;
    push @dsns, $opts{host} if $opts{host};
    push @dsns, $opts{port} if $opts{port};
    push @dsns, "mysql_read_default_file=/etc/my.cnf" if -f "/etc/my.cnf" && $opts{type} eq "mysql";
    my $dsn = join(":", @dsns);

    my $dbh = DBI->connect("dbi:$opts{type}:$dsn", $opts{user}, $opts{password})
        or die $DBI::errstr;
    my @tables = $dbh->tables('', '', '', 'TABLE');
    my $sth = $dbh->table_info({ 'TABLE_TYPE'  => '%',
                             'TABLE_SCHEM' => '',
                             'TABLE_NAME'  => $tables[0] });
    $sth->execute();
                     my $aa = $sth->fetchrow_arrayref;
    print Dumper $aa;
    my @columns = ($aa);
    print Dumper @columns;
    my $c = $sth->fetchall_arrayref;
    $sth = $dbh->column_info('', '', $tables[0], $columns[0]);
    # $sth = $dbh->column_info({ 'TABLE_TYPE'  => '%',
    #                          'TABLE_SCHEM' => '',
    #                          'TABLE_NAME'  => $tables[0],
    #                      'COLUMN_NAME' => $columns[0],
    #                  });

    # http://www.enhyper.com/src/perl5/ilt.html
    $sth->execute();
    $c = $sth->fetchrow_arrayref;
    print Dumper $c;
    my $sql = qq[ SELECT * FROM $tables[0] WHERE 0 = 1 ];
    $sth = $dbh->prepare($sql);
    $sth->execute();
    print Dumper @tables;
    print Dumper $sth->{NAME};
    print Dumper $sth->{TYPE};

    $dbh->disconnect;
}

__END__

=head1 NAME

    database.pl - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

pekepeke <pekepekesamurai+github@gmail.com>
