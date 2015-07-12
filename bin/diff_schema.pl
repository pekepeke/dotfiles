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

my %opts;
GetOptions(
    \%opts,
    'user|u=s', 'password|p=s', 'host|h=s', 'port=i',
    'schema|s=s',
    'input|f=s',
    'help',
) or usage;
usage if $opts{help};

$opts{host} = $opts{host} || '127.0.0.1';
$opts{port} = $opts{port} || 3306;
$opts{user} = $opts{user} || "root";
$opts{input} = $opts{input} || "./ddl.sql";

my $mysql_defaults_file = ";mysql_read_default_file=$ENV{HOME}/.my.cnf";
$mysql_defaults_file = "" unless -f "$ENV{HOME}/.my.cnf";
my $schema_name = $opts{schema} || shift(@ARGV) || "test";

my @DBI_conf = ("DBI:mysql:$schema_name:$opts{host}:$opts{port}$mysql_defaults_file",
    $opts{user}, $opts{password});

my $dbh    = DBI->connect(@DBI_conf);
my $source = do {
    my $schema = SQL::Translator->new(
        parser      => 'DBI',
        parser_args => +{ dbh => $dbh },
    )->translate;
};
my $target = do {
    SQL::Translator->new(
        parser   => 'MySQL',
        filename => $opts{input},
    )->translate;
};
print $opts{input} . "\n";
# AUTO_INCREMENT情報を削る
for my $schema ($source, $target) {
    for my $table ($schema->get_tables) {
        my @options = $table->options;
        if (my ($idx) = grep { $options[$_]->{AUTO_INCREMENT} } 0..$#options) {
            splice $table->options, $idx, 1;
        }
    }
}

# diffの検出
my $std = SQL::Translator::Diff->new(+{
    output_db     => 'MySQL',
    source_schema => $source,
    target_schema => $target,
    producer_args => +{
        quote_field_names => '`',
    },
});
my $diff = $std->compute_differences->produce_diff_sql;
print $diff;




__END__

=head1 NAME

    diff_schema.pl - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

pekepeke <pekepekesamurai+github@gmail.com>
