<?php
// vim:fdm=marker sw=4 ts=4 ft=php expandtab:

$loader = Illuminate\Foundation\AliasLoader::getInstance();
foreach (glob('app/Models/*.php') as $f) {
    $model = basename($f, '.php')."\n";
    $loader->alias($model, "App\Models\{$model}");
}
// $loader->alias('Carbon', Illuminate\Support\Carbon::class);
// DB::listen(function ($query) { dump($query->sql); dump($query->bindings); dump($query->time); });
// mkdir ~/.local/share/psysh
// cd ~/.local/share/psysh
// wget http://psysh.org/manual/ja/php_manual.sqlite
