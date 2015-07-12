#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use FindBin;
use File::Basename;
use File::Slurp;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

my ($opt_help, $opt_in, $opt_out);
Getopt::Long::Configure ("bundling");
GetOptions(
    'h|help' => \$opt_help,
    'i|infile=s' => \$opt_in,
    'o|outfile=s' => \$opt_out,
) or usage;
usage if $opt_help;

my $bin = $FindBin::Bin;
my %INDEX_HASH = ();

#my $target = "$bin/sqls/001_ddl.sql";
my $target_in = $opt_in ? $opt_in : "$bin/../../doc/ddl.sql";
my $target_out = $opt_out ? $opt_out : "$bin/../../doc/ddl_converted.sql";

die("file not found : ${target_in}") unless -f $target_in;

my $text = File::Slurp::read_file($target_in);

$text =~ s/^DROP INDEX (.*) ON (\w+)(.*)$/ALTER IGNORE TABLE $2 DROP INDEX $1$3/mig;
$text =~ s/^DROP TABLE (\w+\s*;\s*)$/DROP TABLE IF EXISTS $1/mig;
$text =~ s/^(CREATE TABLE) (\w+)/$1 IF NOT EXISTS $2/mig;

my @text_fields = map { $_ =~ s/^\s*|\s+text$//mig; $_; } ($text =~ /^\s*\w+\s+text/mig);
push(@text_fields, keys(%INDEX_HASH));
@text_fields = unique(@text_fields);
my %varchar_fields = map { $_ =~ s/^\s*|\s+varchar|\)\s*//ig; split(/\(/, $_); } ($text =~ /^\s*\w+\s+varchar\(\d+\)/mig);

my @vf = grep { $varchar_fields{$_} >= 255; } (keys %varchar_fields);
push(@text_fields, @vf);

for my $field (@text_fields) {
	next if $field eq "id";
	$text =~ s/^(CREATE INDEX.*\(.*?)($field)(\s+)/text_index($1,$2,$3)/mge;

}


sub unique {
	my %h = map { $_ => 1 } @_;
	keys(%h);
}
sub text_index {
	my ($a, $b, $c) = @_;
	"${a}${b}(" . ($INDEX_HASH{$b} || 255) . ")${c}";
}
# print $text;

File::Slurp::write_file($target_out, $text);
print "created : $target_out\n";

__END__

=head1 NAME

    ermddlfix.pl - ddl converter for ERMaster + MySQL

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR


