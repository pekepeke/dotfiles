#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;
use DBI;
use SQL::Translator;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);

my %opts;
GetOptions(
    \%opts,
    'user|u=s', 'password|p=s', 'host|h=s', 'port=i',
    'schema|s=s',
    'output|o=s',
    'help',
) or usage;
usage if $opts{help};

$opts{host} = $opts{host} || '127.0.0.1';
$opts{port} = $opts{port} || 3306;
$opts{user} = $opts{user} || "root";
$opts{output} = $opts{output} || "./ddl.sql";

my $mysql_defaults_file = ";mysql_read_default_file=$ENV{HOME}/.my.cnf";
$mysql_defaults_file = "" unless -f "$ENV{HOME}/.my.cnf";
my $schema_name = $opts{schema} || shift(@ARGV) || "test";

my @DBI_conf = ("DBI:mysql:$schema_name:$opts{host}:$opts{port}$mysql_defaults_file",
    $opts{user}, $opts{password});

# DBIからschema生成
my $translator = do {
    my $dbh    = DBI->connect(@DBI_conf);
    SQL::Translator->new(
        parser      => 'DBI',
        parser_args => +{ dbh => $dbh },
    );
};
my $schema = $translator->translate;
# AUTO_INCREMENT情報を削る
for my $table ($schema->get_tables) {
    my @options = $table->options;
    if (my ($idx) = grep { $options[$_]->{AUTO_INCREMENT} } 0..$#options) {
        splice $table->options, $idx, 1;
    }
}
# MySQL向けのSQLを生成
$translator->producer('MySQL');
my $sql = $translator->translate;
print $sql;

# sql/mysql.sql ファイルに書き込み
my $file = $opts{output};
open my $fh, '>', $file or die $!;
print $fh $sql;
close $fh;


__END__

=head1 NAME

    dump_shema.pl - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

pekepeke <pekepekesamurai+github@gmail.com>

