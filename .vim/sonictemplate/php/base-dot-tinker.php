<?php
// vim:fdm=marker sw=4 ts=4 ft=php expandtab:

$loader = Illuminate\Foundation\AliasLoader::getInstance();
foreach (glob('app/Models/*.php') as $f) {
    $model = basename($f, '.php')."\n";
    $loader->alias($model, "App\Models\{$model}");
}
