my $dbh = DBI->connect("dbi:Oracle:{{_cursor_}}host=localhost;sid=ORCL", "", "", {
    AutoCommit => 1,
    PrintError => 0,
    RaiseError => 1,
    ShowErrorStatement => 1,
    AutoInactiveDestroy => 1,
});
$dbh->disconnect;
