#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use MySQL::KillQuery qw/mysql_killquery/;

use IO::Prompt;

my $defaults_file = "$ENV{HOME}/.my.cnf";

# ルート権限で mysql に接続
my $dbh = DBI->connect(
    'DBI:mysql:database='.($ARGV[0]).";mysql_read_default_file=$defaults_file",
    'root',
    (-f $defaults_file) ? prompt("Password:", -e => '*') : "",
) or die $DBI::errstr;

# 10 秒以上経過した、ロック状態にない root 以外の権限の SELECT クエリを強制終了
while (1) {
    mysql_killquery({
        dbh         => $dbh,
        should_kill => sub {
            my $proc = shift;
            $proc->{User} ne 'root'
                && $proc->{Time} && $proc->{Time} >= 10
                && $proc->{Command} && $proc->{Command} ne 'Killed'
                && $proc->{State} eq 'Locked'
                && $proc->{Info} && $proc->{Info} =~ /^select /i;
            print STDERR join("\t", map { $proc->{$_} } qw(Info Time Command State));
        },
    });
    sleep 5;
}
