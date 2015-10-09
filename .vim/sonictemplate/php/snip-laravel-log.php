
// Log::useDailyFiles(storage_path() . '/logs/laravel.log');
Log::getMonolog()->pushProcessor(new \Monolog\Processor\IntrospectionProcessor(
    \Monolog\Logger::DEBUG, [
        "Monolog\\",
        "Illuminate\\",
        "Symfony\\",
    ]
));
Log::getMonolog()->pushProcessor(new \Monolog\Processor\MemoryUsageProcessor());
Log::getMonolog()->pushProcessor(new \Monolog\Processor\MemoryPeakUsageProcessor());


$sqlLogger = new Illuminate\Log\Writer(new Monolog\Logger('SQL log'));
$sqlLogger->useFiles(app_path() . '/storage/logs/sql.log');


Event::listen('illuminate.query', function ($query, $bindings, $time, $name)
    use ($sqlLogger) {
        $data = compact('bindings', 'time', 'name');

        foreach ($bindings as $i => $binding) {
            if ($binding instanceof DateTime) {
                $bindings[$i] = $binding->format('\'Y-m-d H:i:s\'');
            } elseif (is_string($binding)) {
                $bindings[$i] = "'$binding'";
            }
        }
        $query = str_replace(['%', '?'], array('%%', '%s'), $query);
        $query = vsprintf($query, $bindings);
        $sqlLogger->info($query, $data);
});

