
$pic = pcntl_fork();
if ($pid === -1) {
    throw \RuntimeException("cannot fork");
}
if (!$pid) {
    // child process
     exit(0);
}

pcntl_waitpid($pid, $status);
pcntl_waitpid(-1, $status); // wait all child processes
