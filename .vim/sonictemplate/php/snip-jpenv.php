date_default_timezone_set('Asia/Tokyo');
mb_language('japanese');
mb_internal_encoding('UTF-8');
if (function_exists('ini_set')) {
	ini_set('default_charset', 'UTF-8');
	// httpd.conf or htaccess
	// ini_set('magic_quotes_gpc', false);
	// ini_set('short_open_tag', true);
}

