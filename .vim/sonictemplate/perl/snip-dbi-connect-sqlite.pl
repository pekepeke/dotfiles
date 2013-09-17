my $dbh = DBI->connect("dbi:SQLite:dbname={{_cursor_}}./d.db", {
    AutoCommit => 1,
    PrintError => 0,
    RaiseError => 1,
    ShowErrorStatement => 1,
    AutoInactiveDestroy => 1,
    sqlite_unicode => 1,
    sqlite_use_immediate_transaction => 1,
});
$dbh->disconnect;
