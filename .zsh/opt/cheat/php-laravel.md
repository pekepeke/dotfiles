## sql log

```
    public function register()
    {
        //
        if (PHP_SAPI === 'cli' && config('app.debug')) {
            \DB::listen(function ($query) {
                $sql = $query->sql;
                for ($i = 0, $len = count($query->bindings); $i < $len; $i++) {
                    $sql = preg_replace("/\?/", $query->bindings[$i], $sql, 1);
                }

                \Log::debug('SQL', [
                    'time' => sprintf('%.2f ms', $query->time),
                    'sql' => $sql
                ]);
            });
        }
    }
    public function register()
    {
        if (config('app.debug') && (
                PHP_SAPI === 'cli'
                || (isset($_SERVER['HTTP_CONTENT_TYPE']) && $_SERVER['HTTP_CONTENT_TYPE'] == 'application/json')
                || (isset($_SERVER['HTTP_ACCEPT']) && $_SERVER['HTTP_ACCEPT'] == 'application/json')
            )) {
            \DB::listen(function ($query) {
                $sql = $query->sql;
                for ($i = 0, $len = count($query->bindings); $i < $len; $i++) {
                    $sql = preg_replace("/\?/", $query->bindings[$i], $sql, 1);
                }

                \Log::debug('SQL', [
                    'time' => sprintf('%.2f ms', $query->time),
                    'sql' => $sql
                ]);
            });
        }
    }
```

## eloquent
### 
```
return $this->hasManyThrough(
    Model\Game::class,
    Model\UserGame::class,
    'user_id', // user_game.user_id
    'game_master_id', // game.game_master_id
    null,
    'game_id' // user_game.game_id
);
```
