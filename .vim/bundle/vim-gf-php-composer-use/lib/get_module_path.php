#!/usr/bin/env php
<?php

function usage($argv) {
    printf("usage : %s [composer dir or filepath] [module]\n", $argv[0]);
}

function print_modulepath($argv) {
    $prog = array_shift($argv);
    $composer_path = array_shift($argv);
    $ds = DIRECTORY_SEPARATOR;

    if (!file_exists($composer_path)) {
        exit(1);
    }
    if (is_dir($composer_path)) {
        $composer_path .= $ds . "composer.json";
    }
    $root = dirname($composer_path);
    $composer = json_decode(file_get_contents($composer_path), true);
    $vendor = $root . $ds . "vendor";
    if (isset($composer["config"]["vendor-dir"])) {
        $vendor = $root . $ds . $composer["config"]["vendor-dir"];
    }
    unset($composer, $root, $composer_path);
    $autoload_path = $vendor . $ds . 'autoload.php';
    if (!file_exists($autoload_path)) {
        exit(2);
    }
    $loader = require $autoload_path;
    $map = $loader->getClassMap();

    $found = false;
    foreach ($argv as $component) {
        if (isset($map[$component])) {
            printf("%s\n", $map[$component]);
            $found = true;
            break;
        }
    }
    if (!$found) {
        exit(3);
    }
}

if (count($argv) <= 2 || $argv[1] == "-h") {
    usage($argv);
} else {
    print_modulepath($argv);
}


// $loader = require __DIR__ . '/vendor/autoload.php';

// var_dump($loader->getClassMap());

// print_r(get_declared_classes());
// print_r(get_declared_traits());
// App::bind('fuga', function () {
// });
