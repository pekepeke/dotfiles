#!/usr/bin/env php
<?php
/**
 * Echo php builtin classes, interfaces, functions, constants for vim dictionary
 *
 * eg:# php dict.php | sort > ~/.vim/dict/php_functions.dict
 *
 * @version   $id$
 * @copyright 2009 Heavens hell
 * @author    Heavens hell <heavenshell.jp@gmail.com>
 * @license   New BSD License
 */
$f = false;
$c = false;
$i = false;
$d = false;
$usage = null;
if ($argc > 1) {
    foreach ($argv as $key => $val) {
        if ($argv[$key] === basename(__FILE__)) {
            continue;
        } else if ($argv[$key] === '-c') {
            // Classes
            $c = true;
        } else if ($argv[$key] === '-f') {
            // Functions
            $f = true;
        } else if ($argv[$key] === '-i') {
            // Interfaces
            $i = true;
        } else if ($argv[$key] === '-d') {
            // Constants
            $d = true;
        } else {
            $usage  = 'Usage: php dict.php [-c] [-f] [-i] [-d]' . PHP_EOL;
            $usage .= '       -c display built in classes' . PHP_EOL;
            $usage .= '       -f display built in functions' . PHP_EOL;
            $usage .= '       -i display builtin interfaces' . PHP_EOL;
            $usage .= '       -d display builtin constants' . PHP_EOL;
        }
    }
} else {
    $f = true;
    $c = true;
    $i = true;
    $d = true;
}

if (!is_null($usage)) {
    echo $usage;
    exit(0);
}

$buffer = '';
if ($f === true) {
    $functions = get_defined_functions();
    $buffer    = join("\n",$functions["internal"]) . PHP_EOL;
}

if ($c === true) {
    $class = get_declared_classes();
    foreach ($class as $value) {
        $buffer .= $value . PHP_EOL;
    }
}

if ($i === true) {
    $interface = get_declared_interfaces();
    foreach ($interface as $value) {
        $buffer .= $value . PHP_EOL;
    }
}

if ($d === true) {
    $constants = get_defined_constants();
    foreach ($constants as $key => $value) {
        $buffer .= $key . PHP_EOL;
    }
}

echo $buffer;
// $lines = explode(PHP_EOL, $buffer); sort($lines);
// echo implode(PHP_EOL, $lines);
