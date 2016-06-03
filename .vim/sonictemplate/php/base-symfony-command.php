<?php

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class {{_name_}} extends Command
{
    protected function configure()
    {
        $this
            ->setName('{{_name_}}')
            ->setDescription('{{_name_}}');
        // $this
        //     ->addArgument(
        //         'name',
        //         InputArgument::OPTIONAL,
        //         'desc'
        //     )
        //     ->addOption(
        //         'name',
        //         null,
        //         InputOption::VALUE_NONE,
        //         'desc'
        //     );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        // $name = $input->getArgument('name');
        // $input->getOption('yell')
    }
}


if (basename(__FILE__) == basename($_SERVER['PHP_SELF'])) {
    use Symfony\Component\Console\Application;

    $application = new Application();
    $application->add(new {{_name_}});
    $application->run();
}
