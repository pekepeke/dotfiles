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
Getopt::Long::Configure ("bundling");
GetOptions(
    'h|help' => \$opt_help,
) or usage;
usage if $opt_help;

for my $fpath (@ARGV) {
    my $tpl = $fpath;
    # $tpl =~ s/\.([^\.]*)$/.tpl/;
    $tpl =~ s/\.([^\.]*)$/.twig/;

    open my $fp, '<', $fpath or die "$fpath: $!";
    my @s = <$fp>;
    close($fp);

    my @lines;
    for my $s (@s) {
        $s =~ s/<\?php/{{/g;
        $s =~ s/;\s*\?>/ }}/g;

        # helpers
        $s =~ s/echo \$this->Paginator->/paginator./g;
        $s =~ s/echo \$this->Html->/html./g;
        $s =~ s/echo \$this->Form->/form./g;
        $s =~ s/\$this->Paginator->/paginator./g;
        $s =~ s/\$this->Html->/html./g;
        $s =~ s/\$this->Form->/form./g;

        $s =~ s/array\(([^\)]*)\)/{array2twig($1)}/ge;
        $s =~ s/echo __\(('.*')\)/$1|trans/g;
        $s =~ s/__\(('[^']*')\)/$1|trans/g;
        $s =~ s/__\(('.*)/{complextrans($1)}/ge;

        $s =~ s/{{ (form|paginator|html)(.*) }}/{{ $1$2|raw }}/g;

        $s =~ s/\$([\w\[\]']+)/to_var($1)/ge;
        $s =~ s/echo //g;
        $s =~ s/h\((.*)\)/$1/g;

        $s =~ s/(\s*)(form\..*);/$1\{\{ $2|raw }}/g;
        $s =~ s/(\s*)(paginator\..*);/$1\{\{ $2|raw }}/g;
        $s =~ s/(\s*)(html\..*);/$1\{\{ $2|raw }}/g;

        $s =~ s/(\s*)foreach\s*\((.*) as (.*)\):\s*\?>/$1\{% for $3 in $2 %}/g;
        $s =~ s/(\s*){{\s*endforeach\s*}}/\{\% endfor %\}/g;

        # specific patterns
        $s =~ s/paginator.counter\(array\(/{{ paginator.counter({/g;
        $s =~ s/'([^']*)'\s*=>\s*/$1 : /g;
        $s =~ s/(^\s*)\)\);$/$1})|raw }}/g;
        $s =~ s/(\.postLink.*)\)\)/.postLink$1)/g;
        $s =~ s/([\w\.]+\.id})/0 : $1/ if ($s =~ /html\.(link|postLink)/);
				$s =~ s/postLink\.postLink/postLink/g;
        $s =~ s/' \. '/' ~ '/g;
        $s =~ s/('delete',\s*)([^:,]+})/$1 0 : $2/g;
        $s =~ s/(\|trans\s*)\.(\s*')/$1~$2/g;
        $s =~ s/id'\}\),/id')},/g;

        $s =~ s/^\s*<\?php$//g;
        $s =~ s/^\s*{{$//g;
        $s =~ s/\?>//g;
        $s =~ s/{{ {%/{%/; # for index.twig
        push @lines, $s;
    }
    open my $ofp, '>', $tpl or die "$tpl: $!";
    print $ofp @lines;
    close($ofp);
    # print @lines;
}

sub to_var {
    my $s = shift;
    $s =~ s/\['/./g;
    $s =~ s/'\]//g;
    return $s;
}
## TODO
sub complextrans {
    my $s = shift;
    # my $pos = index($s, ")");
    # if ($pos > 0 && index(substr($s, 0, $pos), "()") > 0) {
    # } else {
    #     $s = substr($s, 0, $pos) . "|trans" . substr($s, $pos);
    # }
    # print substr($s, 0, $pos) . "|trans" . substr($s, $pos);
    # print "complex:".$s;
    return $s;
}
sub array2twig {
    my $s = shift;
    my $is_hash = $s =~ /=>/;
    if ($is_hash) {
        $s =~ s/=>/:/g;
        $s = "{$s}";
    } else {
        $s = "[$s]";
    }
    return $s;
}

__END__

=head1 NAME

    ctp2twig.pl - ctp ファイルを twig に通してもだいたいエラーにならないよう変換します

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR


