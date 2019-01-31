<?php
// vim:fdm=marker sw=2 ts=2 ft=php expandtab:

foreach (glob('app/Models/*.php') as $f) {
    $model = basename($f, '.php')."\n";
    $loader->alias($model, "App\Models\{$model}");
}
