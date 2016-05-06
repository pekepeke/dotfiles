if (!function_exists('putlog')) {
    function putlog() {
        $filename = "/tmp/debug.log";

        $i = 1;
        $trace = debug_backtrace(null, 2);
        !isset($trace[$i]) && $i = 0;
        $h = sprintf("%s %s[%d] :", date('Y-m-d H:i:s'), $trace[$i]["file"], $trace[$i]["line"]);
        $output = call_user_func_array('sprintf', func_get_args()) . "\n";
        file_put_contents($filename, $output, FILE_APPEND);
    }
}
