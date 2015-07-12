#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use DBI;
use Encode;
use SQL::Translator;
use Data::Dumper;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;

my $CONV_HTML_CHARSET_ORG = 'content="text/html; charset=iso-8859-1"';
my $CONV_HTML_CHARSET_NEW = 'content="text/html; charset=utf8"';

my %opts;
my @dbi_config;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}


sub main {
    my $dbh = connect_db();

    my $tr = SQL::Translator->new();
    #対象のdbms
    $tr->parser("SQL::Translator::Parser::MySQL");

    #parse結果の出力形式
    $tr->producer("SQL::Translator::Producer::HTML");
#    $tr->producer("SQL::Translator::Producer::YAML");

    #dbにある全てのtable nameを取得しましょう
    my $tbl_names = get_all_table_names($dbh);

    my $table_info = "";

    for my $tbl ( @$tbl_names ){
	my $sql = "show create table $tbl";
	my $sth = $dbh->prepare($sql);

    #対象テーブルがviewだと、execute()でエラーになります
    #mysqlでのテーブルorビューの判定は、INFORMATION_SCHEMA.TABLESでも可
    if( $sth->execute() ){
        my $ret_tmp = $sth->fetchrow_arrayref();
        if(ref($ret_tmp) eq 'ARRAY' and @$ret_tmp>0){
            $table_info .= $ret_tmp->[1] .";\n\n";
        }
    }

    }

    $tr->parser->($tr, $table_info);
    my $output = $tr->producer->($tr);
    $output =~ s/\\n/<br>/o;
    $output =~ s/$CONV_HTML_CHARSET_ORG/$CONV_HTML_CHARSET_NEW/o;

    print $output;
}


sub get_all_table_names {
    my ($dbh) = @_;
    my $sql=<<EOF;
show tables;
EOF
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    my @table_names;
    while (my $table_name = $sth->fetchrow_array() ){
        push(@table_names, $table_name);
    }
    return \@table_names;
}

sub connect_db {
    my $dbh = DBI->connect( @dbi_config );
    # my $dbh = DBI->connect("DBI:mysql:database=db;host=127.0.0.1", "root", "root");
    $dbh->do("SET NAMES utf8") or die "cannot set encoding";
    return $dbh;
}

Getopt::Long::Configure("bundling");
GetOptions(
    \%opts,
    'user|u=s', 'password|p=s', 'host|h=s', 'ddl|d=s' , 'port=i',
    'schema|s=s',
    'help',
) or usage;

usage if $opts{help};
$opts{host} = $opts{host} || '127.0.0.1';
$opts{port} = $opts{port} || 3306;
my $schema_name = $opts{schema} || shift(@ARGV) || "test";
@dbi_config = ("DBI:mysql:$schema_name:$opts{host}:$opts{port}", $opts{user}, $opts{password});

main();

__END__

=head1 NAME

db2htmlreport.pl - create html files of database report

=head1 SYNOPSIS

    db2htmlreport.pl [-h] -- cmd args...

=head1 DESCRIPTION

create html files of database report

=head1 OPTIONS

=over 4

=item -h --help

show help

=item -u [user] --user=[user]

specific database user

=item -p [password] --password=[password]

specific password

=item -h [host] --host=[host]

specific database host

=item -p [port] --port=[port]

specific database port

=item -d [filename] --ddl=[filename]

specific filename of ddl

=item -s [schema] --schema=[schema]

specific database schema

=back


=head1 AUTHOR

pekepeke

=cut

