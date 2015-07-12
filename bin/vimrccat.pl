#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;
use LWP::Simple;

use File::Basename;
use File::Spec::Functions;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

sub is_http {
    my $url = shift;
    $url =~ m!^https?://!;
}

sub convert_url {
    my $url = shift;
    $url =~ s!(https?://github.com/.*?/.*?/)blob/!$1raw/!;
    $url;
}

sub read_file {
    my $path = shift;
    open my $fh, '<', $path or die "$path: $!";
    my @content = <$fh>;
    close($fh);
    join("\n", @content);
}

my $opt_help;
Getopt::Long::Configure("bundling");
GetOptions(
    'h|help' => \$opt_help,
) or usage;
usage if $opt_help;

my $path = "https://github.com/yuroyoro/dotfiles/raw/master/.vimrc";
$path = "https://github.com/jceb/vimrc/blob/master/vimrc";
my $is_http = is_http($path);

$path = convert_url($path) if $is_http;
my $content = $is_http ? get($path) : read_file($path);
die "Couldn't get it!" unless defined $content;

my $relative_url = dirname($path);
# print dirname($path);
# print catfile("a", "b");
for (split(/\r?\n/, $content)) {
    my $so_path;
    if (m/^\s*so(urce)?\s+(.+)/) {
        $so_path = $2;
    }
    if (m/^\s*exec?u?t?e?\s+['"]so(urce)?\s*(.+?)['"]/) {
        $so_path = $2;
    }
    if (m/^\s*exec?u?t?e?\s+['"]so(urce)?\s*['"].*?['"](.+?)['"]/) {
        $so_path = $2;
    }
    if ($so_path) {
        if ($is_http) {
            my ($fname, $dir, $suffix) = fileparse($so_path);
            $dir =~ s!^~/!!;
            $dir =~ s!^\$HOME/!!;
            $dir =~ s!^\/(home|Users)/.+?/!!;
            # TODO
            my @entries = ("$relative_url/$fname", "$relative_url/$dir/$fname");
            # if ($dir =~ /.vim/) {
            #     $dir =~ s!/.vim/!/!;
            #     push @entries, "$relative_url/$dir/$fname";
            # }
            my $is_success = 0;
            for my $source_url (@entries) {
                if (head($source_url)) {
                    printf('" %s =========================== {{{' . "\n", $_);
                    print get($source_url);
                    print '" =========================== }}}' . "\n";
                    $is_success = 1;
                    last;
                }
            }
            print $_ . "\n" unless $is_success;
            # print $fname, "-", $dirs, "-", $suffix, "\n";
        } else {
            if (-f $so_path) {
                printf('" %s =========================== {{{' . "\n", $_);
                # printf('" %s {{{' . "\n", $_);
                print read_file($so_path);
                # print '" }}}' . "\n";
                print '" =========================== }}}' . "\n";
            } else {
                print $_ . "\n";
            }
        }
    } else {
        # s/^"([^ \t])/" $1/;
        print $_ . "\n";
    }
    # print;
}

__END__

=head1 NAME

    vimcat.pl - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

 <>
