```
// ini_set("max_execution_time",180);
xhprof_enable();

// execute

// stop profiler
$xhprof_data = xhprof_disable();

$XHPROF_ROOT        = '/var/www/tools/xhprof';  //xhprofをインストールしたディレクトリ
$XHPROF_SOURCE_NAME = 'run1';
include_once $XHPROF_ROOT . "/xhprof_lib/utils/xhprof_lib.php";
include_once $XHPROF_ROOT . "/xhprof_lib/utils/xhprof_runs.php";

$xhprof_runs = new XHProfRuns_Default();
$run_id = $xhprof_runs->save_run($xhprof_data, $XHPROF_SOURCE_NAME);

// printf('<a href="%s?run=%s&source=%s">xhprof result</a>', "http://localhost/xhprof/xhprof_html/index.php", $run_id, $XHPROF_SOURCE_NAME);
```
