#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use File::KeePass;
use Carp;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;
use Config::Pit;

my ($opt_help, $opt_verbose, $opt_show, $opt_basic, $opt_backup);

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

sub clip_cmd {
    my $os = $^O;
    return "pbcopy" if $os =~ /darwin/;
    return "putclip" if $os =~ /mswin/i;
    #if $os =~ /linux/;
    #return "xclip -i -selection clipboard";
    return "xsel --input --clipboard";
}

sub format_entry {
    my $e = shift;
    my ($s, $pwd) = ("", $e->{password});
    if ($opt_verbose) {
        $s .= sprintf "##### %-s #####\n", $e->{title};
        for my $k ("username", "url", "comment") {
            chomp($e->{$k});
            printf "%-10s : %s\n", $k, $e->{$k};
        }
        $s .= sprintf "%-10s :%s\n", "password",
            $opt_show ? $pwd : "*" x length($pwd);
    } elsif ($opt_basic) {
        $s .= sprintf "curl --basic --user %s:%s %s\n", $e->{username}, $pwd, $e->{url};
    } else {
        $s .= sprintf "%-20s :%s\n", $e->{title},
            $opt_show ? $pwd : "*" x length($pwd);
    }
    $s;
}

sub show_entries {
    my $entries = shift;
    my $g = shift;
    my $matcher = shift;
    my $level = shift;

    my $last_pass;
    my $is_gtitle = 0;
    my $s = "";

    for my $e (@{$entries}) {
        next if ($e->{title} =~ /Meta-Info/);
        next unless $matcher->($e->{title});
        $is_gtitle = 1 &&
            printf "%s %s\n",
                "# " . "=" x 40 . ">>" x ($level-1) ,
                $g->{title} unless $is_gtitle;
        chomp($e->{title});

        $s = format_entry($e);
        print $s;

        if ($opt_basic) {
            $last_pass = $s;
        } else {
            $last_pass = $e->{password};
        }
    }
    $last_pass;
}

sub find_groups {
    my $k = shift;
    my $matcher = shift;
    my $level = shift || 1;
    my $last_pass;

    for my $g (@{$k->{groups}}) {
        next if (!$opt_backup && $g->{title} =~ "Backup");
        $last_pass = show_entries($g->{entries}, $g, $matcher, $level) || $last_pass;
        $last_pass = find_groups($g, $matcher, $level + 1) || $last_pass if ($g->{groups}) ;
    }
    $last_pass;
}


my $path;
my $pass;
GetOptions(
    'h|help' => \$opt_help,
    'f|file=s' => \$path,
    'p|password=s' => \$pass,
    'B|backup' => \$opt_backup,
    'b|basic' => \$opt_basic,
    's|show' => \$opt_show,
    'v|verbose' => \$opt_verbose,
) or usage;

unless ($path) {
    my $config = pit_get("keepass.kdb", require => {
        "path" => "",
        "password" => "",
    });
    $path = $config->{path};
    $pass = $config->{password};
}

usage if $opt_help || not $path;

$path =~ s/\~/$ENV{HOME}/g;

my $k = File::KeePass->new;
eval { $k->load_db($path, $pass); }
    or die "Can't open file : $path - $@";
$k->unlock;

my $matcher = sub {
    my ($str) = @_;
    #our $re = join("|", map{ quotemeta $_ } @ARGV) || "";
    for my $s (@ARGV) {
        #return 0 unless !$re || $e->{title} =~ /$re/;
        return 0 unless (index($str, $s) != -1);
    }
    1;
};


my $last_pass = find_groups($k, $matcher);

if ($last_pass) {
    chomp($last_pass);
    system sprintf("echo '%s' | %s", $last_pass, clip_cmd);
}

Config::Pit::set("keepass", data => {
    path => $path,
    password => $pass,
});

__END__

=head1 NAME

    keepass.pl - command line keepass client

=head1 SYNOPSIS

usage : keepass.pl -f [file] -p [pass] [search words ...]

=head1 OPTIONS

=over 4

=item * -f [file], --file [file]

specify keepass file

=item * -p [password], --password [password]

specify password

=item * -B, --backup

show buckup entries

=item * -v, --verbose

verbose output

=item * -s, --show

show password field

=back

=head1 AUTHOR

pekepeke <pekepekesamurai+github@gmail.com>
