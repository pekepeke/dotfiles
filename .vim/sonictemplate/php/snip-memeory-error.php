ini_set('memory_limit', '32M');

$csv = [];
$csvStr = '';
$count = 20000;
$colLength = 20;

foreach (range(0, $count-1) as $index => $current) {
    $item = range(0, $colLength - 1);
    $csv[] = $item;
    $csvStr .= implode(",", $item) . PHP_EOL;
}
printf("mem: %s, mem_real: %s\n", number_format(memory_get_usage()), number_format(memory_get_usage(true)));
