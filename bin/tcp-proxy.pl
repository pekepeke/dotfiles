#!/usr/bin/perl
#
# Peteris Krumins (peter@catonmat.net)
# http://www.catonmat.net  --  good coders code, great reuse
#
# A simple TCP proxy that implements IP-based access control
# Currently the ports are hard-coded, and it proxies
# 0.0.0.0:1080 to localhost:55555.
#
# Written for the article "Turn any Linux computer into SOCKS5
# proxy in one command," which can be read here:
#
# http://www.catonmat.net/blog/linux-socks5-proxy
# https://github.com/pkrumins/perl-tcp-proxy
#

use warnings;
use strict;

use IO::Socket;
use IO::Select;

my @allowed_ips = ('127.0.0.1/32', '10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16');
my $ioset = IO::Select->new;
my %socket_map;

my $debug = 1;

sub in_ipaddr {
    my ($cidr, $ip) = @_;
    my ($netip, $mask) = split("/", $cidr);
    my ($accept, $remote) = (ip2long($netip) >> (32 - $mask), ip2long($ip) >> (32 - $mask));
    return $accept == $remote;
}

sub ip2long {
    return unpack("l*", pack("l*", unpack("N*", inet_aton(shift))));
}

sub long2ip {
    return inet_ntoa(pack("N*", shift));
}

sub new_conn {
    my ($host, $port) = @_;
    return IO::Socket::INET->new(
        PeerAddr => $host,
        PeerPort => $port
    ) || die "Unable to connect to $host:$port: $!";
}

sub new_server {
    my ($host, $port) = @_;
    my $server = IO::Socket::INET->new(
        LocalAddr => $host,
        LocalPort => $port,
        ReuseAddr => 1,
        Listen    => 100
    ) || die "Unable to listen on $host:$port: $!";
}

sub new_connection {
    my $server = shift;
    my $client = $server->accept;
    my $client_ip = client_ip($client);

    unless (client_allowed($client)) {
        print "Connection from $client_ip denied.\n" if $debug;
        $client->close;
        return;
    }
    print "Connection from $client_ip accepted.\n" if $debug;

    my $remote = new_conn('localhost', 55555);
    $ioset->add($client);
    $ioset->add($remote);

    $socket_map{$client} = $remote;
    $socket_map{$remote} = $client;
}

sub close_connection {
    my $client = shift;
    my $client_ip = client_ip($client);
    my $remote = $socket_map{$client};

    $ioset->remove($client);
    $ioset->remove($remote);

    delete $socket_map{$client};
    delete $socket_map{$remote};

    $client->close;
    $remote->close;

    print "Connection from $client_ip closed.\n" if $debug;
}

sub client_ip {
    my $client = shift;
    return inet_ntoa($client->sockaddr);
}

sub client_allowed {
    my $client = shift;
    my $client_ip = client_ip($client);
    # return grep { $_ eq $client_ip } @allowed_ips;
    return grep { in_ipaddr($_, $client_ip) } @allowed_ips;
}

print "Starting a server on 0.0.0.0:1080\n";
my $server = new_server('0.0.0.0', 1080);
$ioset->add($server);

while (1) {
    for my $socket ($ioset->can_read) {
        if ($socket == $server) {
            new_connection($server);
        }
        else {
            next unless exists $socket_map{$socket};
            my $remote = $socket_map{$socket};
            my $buffer;
            my $read = $socket->sysread($buffer, 4096);
            if ($read) {
                $remote->syswrite($buffer);
            }
            else {
                close_connection($socket);
            }
        }
    }
}

