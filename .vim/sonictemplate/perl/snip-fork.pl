my $pid = fork;
if (defined $pid) {
    if ($pid) {
        # parent process
        my $handler = sub {
            my $sig = shift;

            kill HUP => $pid;
            waitpid($pid, 0);

            die "killed by $sig";
            exit(1);
        };
        local $SIG{INT} = $handler; # Ctrl-c
        local $SIG{HUP} = $handler; # HUP
        local $SIG{QUIT} = $handler; # QUIT
        local $SIG{KILL} = $handler; # KILL
        local $SIG{TERM} = $handler; # TERM

        wait();
    } else {
        sleep(10);
        # child process
        exit(0);
    }
} else {
    die "Cannot fork: $!";
}

