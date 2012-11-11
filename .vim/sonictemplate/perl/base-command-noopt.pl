#!/usr/bin/env perl

use strict;
use warnings;

package {{_name_}};
our $VERSION = '0.0.1';

sub new {
    my $class = shift;
    my $self = {};
    my %opt = @_;
    my @props = qw/
    /;

    for (@props) {
        if ($opt{$_}) {
            $self->{$_} = $opt{$_};
        } else {
            die "required $_";
        }
    }

    bless $self, $class;

    $self->init();

    return $self;
}

sub init {
    my $self = shift;

}

sub run {
    my ($self, $command, $args) = @_;

    $command ||= '';
    $command =~ s/-/_/g;

    if (my $cmd = $self->can("_cmd_$command")) {
        $cmd->($self, $args);
    } else {
        $self->_cmd_help();
    }
};

sub _cmd_help {
    my ($self, $args) = @_;
    my $prog = "{{_name_}}";

    print <<"...";
$prog $VERSION

Usage:
    $prog help                 Show this message

Example:
    $prog help
...
}

package main;
use utf8;

use Cwd 'abs_path';

use Carp;
use Data::Dumper;

sub main {
    {{_cursor_}}
    my $xxx_dir = abs_path($ENV{'{{_expr_:toupper(expand('%:r'))}}_ROOT'} || $ENV{'HOME'} . '/.{{_name_}}');
    my $command = shift @ARGV;
    my $args = \@ARGV;

    {{_name_}}->new(
        {{_name_}}_dir        => $xxx_dir,
    )->run($command, $args);
}

main() unless caller;

__END__

