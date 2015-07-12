#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Carp;
use Data::Dumper;
use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use Pod::Usage;

sub usage {
    pod2usage(-verbose => 2);
    exit 1;
}

sub get_active_network {
    my @services = ("Ethernet", "Wi-Fi");

    my @texts = split /\n/, `networksetup -listnetworkserviceorder`;
    for my $service (@services) {
        my $is_status = 0;
        for my $line (@texts) {
            if ($is_status) {
                if ($line =~ /Device: (\w+)\)/) {
                    return $service;
                }
                last;
            }
            $is_status = 1 if (index($line, $service) != -1);
        }
    }
}

sub set_webproxy {
    my $activate = shift;
    my $proxy_uri = shift;
    my ($host, $port);
    my $network = get_active_network();
    my @commands;

    if ($activate) {

        if ($proxy_uri =~ /^([\w0-9\.\-_]+):(\d+)$/) {
            $host = $1;
            $port = $2;
        }

        die "can't parse $proxy_uri" unless (defined($host) and defined($port));

        @commands = (
            "networksetup -setwebproxy $network $host $port",
            "networksetup -setsecurewebproxy $network $host $port",
            "networksetup -setwebproxystate $network on",
            "networksetup -setsecurewebproxystate $network on",
        );
        # -setftpproxy networkservice domain portnumber
        # -setftpproxystate networkservice on | off]
        # -setstreamingproxy networkservice domain portnumber
        # -setstreamingproxystate networkservice on | off]
        # -setgopherproxy networkservice domain portnumber
        # -setgopherproxystate networkservice on | off]
        # -setsocksfirewallproxy networkservice domain portnumber
        # -setsocksfirewallproxystate networkservice on | off]

    } else {
        @commands = (
            "networksetup -setwebproxystate $network off",
            "networksetup -setsecurewebproxystate $network off",
        );
    }
    for my $cmd (@commands) {
        print $cmd . "\n";
        system("sudo $cmd");
    }

}


my %opts;
Getopt::Long::Configure("bundling");
GetOptions(\%opts, qw(
    help|h=s
    disable|d
)) or usage;
usage if $opts{help};

if ($opts{disable}) {
    set_webproxy(0, "");
} else {
    set_webproxy(1, $ARGV[0]);
}


__END__

=head1 NAME

    proxyset - desc

=head1 SYNOPSIS


=head1 OPTIONS


=head1 AUTHOR

 <>
