date_default_timezone_set('Asia/Tokyo');
mb_language('japanese');
mb_internal_encoding('UTF-8');
if (function_exists('ini_set')) {
	ini_set('default_charset', 'UTF-8');
	// httpd.conf or htaccess
	// ini_set('magic_quotes_gpc', false);
	// ini_set('short_open_tag', true);
	ini_set('display_errors', 1);
	ini_set('log_errors', 1);
	// ini_set('error_log', 'path/to/log');
}
// if (function_exists('set_exception_handler')) {
// 	set_exception_handler('php_exception_handler');
// }
// if (function_exists('register_shutdown_function')) {
// 	register_shutdown_function('php_shutdown_handler');
// }
error_reporting(-1);


