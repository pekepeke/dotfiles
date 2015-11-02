// ------------------------------------------------------- START
if (function_exists('set_error_handler')) {
    set_error_handler('php_error_handler');
}

if (function_exists('set_exception_handler')) {
    set_exception_handler('php_exception_handler');
}
if (function_exists('register_shutdown_function')) {
    register_shutdown_function('php_shutdown_handler');
}

function _format_error($errno, $errmsg, $errfile, $errline, $errcontext) {
    // エラーの種類を表す連想配列を定義
    $errortype = array( 1=>"Error", 2=>"Warning", 4=>"Parsing Error", 8=>"Notice",
                        16=>"Core Error", 32=>"Core Warning",
                        64=>"Compile Error", 128=>"Compile Warning",
                        256=>"User Error", 512=>"User Warning", 1024=>"User Notice",
                        2048=>'Strict', 4096 => 'Recoverable');
    return "$errortype[$errno] : $errmsg - $errfile($errline)";
}

function php_error_handler($errno, $errmsg, $errfile, $errline, $errcontext) {
    static $reporting;
    !isset($reporting) && $reporting = error_reporting();
    if (!($errno & $reporting)) { return false; }
    error_log("PHP " . _format_error($errno, $errmsg, $errfile, $errline, $errcontext));
    return false;
}

function php_shutdown_handler() {
    $error = error_get_last();
    if ($error['type'] == E_ERROR) {
        error_log(sprintf("Fatal Error : %s - %s[%d]", $error['message'], $error['file'], $error['line']));
        exit(255);
    }
    return false;
}

function php_exception_handler($e) {
    error_log(sprintf("Uncaught Exception : %s - %s[%d](%d)", $e->getMessage(), $e->getFile(), $e->getLine(), $e->getCode()));
    exit(255);
    return false;
}
// ------------------------------------------------------- END
