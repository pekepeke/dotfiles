#!/bin/bash

if ! which php >/dev/null; then
  echo "command not found: php" 2>&2
  exit 1
fi
for f in composer.json Vendor composer.phar; do
  if [ -e "$f" ]; then
    echo "already exists: $f" 1>&2
    exit 1
  fi
done

cat <<'EOM' > composer.json
{
    "name": "example-app",
    "repositories": [
        {
            "type": "pear",
            "url": "http://pear.cakephp.org"
        }
    ],
    "require": {
        "php": ">=5.3.1",
        "pear-cakephp/cakephp": ">=2.4.5",
        "FriendsOfCake/crud": "3.*",
        "cakephp/debug_kit": "2.2.*"
    },
    "require-dev": {
        "phpunit/phpunit": "3.7.*"
    },
    "config": {
        "bin-dir": "bin/",
        "vendor-dir": "Vendor/"
    }
}
EOM
#         "davedevelopment/phpmig": "*",

curl -sS https://getcomposer.org/installer | php
php composer.phar install
Vendor/pear-pear.cakephp.org/CakePHP/bin/cake bake project app

cat <<'EOM'
INSTALLING FINISH
=================

# please fixes following

## app/webroot/index.php, app/webroot/test.php

define(
    'CAKE_CORE_INCLUDE_PATH',
    ROOT . DS . '/Vendor/pear-pear.cakephp.org/CakePHP'
);

## app/Console/cake.php

    ini_set('include_path', $root . PATH_SEPARATOR .  $root . $ds . 'Vendor' . $ds . 'pear-pear.cakephp.org' . $ds . 'CakePHP' . PATH_SEPARATOR . ini_get('include_path'));

## Config/bootstrap.php

// composerのautoloadを読み込み
// CakePHPのオートローダーをいったん削除し、composerより先に評価されるように先頭に追加する
// https://github.com/composer/composer/commit/c80cb76b9b5082ecc3e5b53b1050f76bb27b127b を参照

require ROOT . '/Vendor/autoload.php';
spl_autoload_unregister(array('App', 'load'));
spl_autoload_register(array('App', 'load'), true, true);

App::build(array(
    'Plugin' => array(ROOT . DS . 'Plugin' . DS),
));
CakePlugin::loadAll();

# Run instantly

## edit core.php
date_default_timezone_set('Asia/Tokyo');
if (function_exists('mb_language')) {
    mb_language('Japanese');
    ini_set('mbstring.detect_order', 'auto');
    ini_set('mbstring.http_input'  , 'pass');
    ini_set('mbstring.http_output' , 'pass');
    ini_set('mbstring.internal_encoding', 'UTF-8');
    ini_set('mbstring.script_encoding'  , 'UTF-8');
    ini_set('mbstring.encoding_translation', 'none');
    ini_set('mbstring.substitute_character', 'none');
    ini_set('mbstring.strict_detection', 'Off');
    mb_regex_encoding('UTF-8');
}

## execute following command

    php -S localhost:8111 -t app/webroot

EOM

