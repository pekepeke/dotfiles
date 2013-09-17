my $dbh = DBI->connect("dbi:mysql:{{_cursor_}}db:localhost:3306", "user", "pass", {
    AutoCommit => 1,
    PrintError => 0,
    RaiseError => 1,
    ShowErrorStatement => 1,
    AutoInactiveDestroy => 1,
    mysql_enable_utf8 => 1,
    mysql_auto_reconnect => 0,
});

$dbh->disconnect;
