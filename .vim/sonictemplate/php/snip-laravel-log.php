
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
        // for MongoDate
        $query = preg_replace_callback('!:{"sec":(\d+),"usec":(\d+)}!', function($m) {
            $str = preg_replace('!(\+[\d:]+|Z)$!', sprintf('.%03d\1', $m[2]), date(DATE_ISO8601, $m[1]));
            return sprintf(':ISODate("%s")', $str);
        }, $query);
        $query = str_replace(['%', '?'], array('%%', '%s'), $query);
        $query = vsprintf($query, $bindings);
        $sqlLogger->info($query, $data);
});

