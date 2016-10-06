
public function handlePcntlSignal($signo)
{
    switch ($signo) {
    case SIGTERM:
    case SIGINT:
        // if ($this->isChildProcess) {
        //     exit(1);
        // }
        exit(255);
        break;
    case SIGHUP:
        break;
    // case SIGUSR1:
    //     break;
    }
}

declare(ticks = 1);
pcntl_signal(SIGTERM, array($this, 'handlePcntlSignal'));
pcntl_signal(SIGINT, array($this, 'handlePcntlSignal'));
