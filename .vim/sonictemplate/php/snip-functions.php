if (!function_exists('h')) {
	function h($s) {
		return is_array($s) ? array_map("h", $s) : htmlspecialchars($s, ENT_QUOTES);
	}
}
if (!function_exists('nf')) {
	function nf($v) {
		return number_format($v);
	}
}
if (!function_exists('d')) {
	function d() {
		echo '<pre style="background:#fff;color:#333;border:1px solid #ccc;margin:2px;padding:4px;font-family:monospace;font-size:12px">';
		foreach (func_get_args() as $v) var_dump($v);
		echo '</pre>';
	}
}
if (!function_exists('render')) {
	function render($view_path, $vars) {
		ob_start();
		extract($vars);
		include $view_path;
		$content = ob_get_clean();
		return $content;
	}
}

if (!function_exists('is_alpha')) {
	function is_alpha($string) {
		if ( function_exists('ctype_alpha') ) return ctype_alpha($string);
		return (bool) preg_match('/^[a-zA-Z] $/', $string);
	}
}

if (!function_exists('is_alnum')) {
	function is_alnum($string) {
		if ( function_exists('ctype_alnum') ) return ctype_alnum(strval($string));
		return (bool) preg_match('/^[a-zA-Z0-9] $/', $string);
	}
}

if (!function_exists('is_alnum')) {
	function is_digit($string) {
		if ( function_exists('ctype_digit') ) return ctype_digit(strval($string));
		return (bool) preg_match('/^[0-9] $/', $string);
	}
}

if (!function_exists('in_range')) {
	function in_range($i, $min, $max) {
		return ($i >= $min) && ($i <= $max); // >
	}
}

if (!function_exists('is_date')) {
	function is_date($date, $opt) {
		$date   = str_replace(array('\'', '-', '.', ',', ' '), '/', $date);
		$dates  = array_clean(explode('/', $date));

		if ( count($dates) != 3 ) return false;

		switch ( $opt ) {
			case 'iso'  :
				$year   = $dates[0];
				$month  = $dates[1];
				$day    = $dates[2];
			break;

			case 'usa'  :
				$year   = $dates[2];
				$month  = $dates[0];
				$day    = $dates[1];
			break;

			case 'eng'  :
				$year   = $dates[2];
				$month  = $dates[1];
				$day    = $dates[0];
			break;

			default     :
				return false;
		}

		if ( !is_numeric($month) || !is_numeric($day) || !is_numeric($year) ) {
			return false;
		} elseif ( !checkdate($month, $day, $year) ) {
			return false;
		} else {
			return true;
		}
	}
}
if (!function_exists('bytelen')) {
	function bytelen($data) {
		return strlen(bin2hex($data)) / 2;
	}
}

if (!function_exists('str_starts_with')) {
	function str_starts_with($haystack, $needle){
		return strpos($haystack, $needle, 0) === 0;
	}
}

if (!function_exists('str_ends_with')) {
	function str_ends_with($haystack, $needle){
		$length = (strlen($haystack) - strlen($needle));
		if( $length < 0) return false; // >
		return strpos($haystack, $needle, $length) !== false;
	}
}

if (!function_exists('str_matches_in')) {
	function str_matches_in($haystack, $needle){
		return strpos($haystack, $needle) !== false;
	}
}
if (!function_exists('http_response_code')) {
	function http_response_code($code = NULL) {

		if ($code !== NULL) {

			switch ($code) {
			case 100: $text = 'Continue'; break;
			case 101: $text = 'Switching Protocols'; break;
			case 200: $text = 'OK'; break;
			case 201: $text = 'Created'; break;
			case 202: $text = 'Accepted'; break;
			case 203: $text = 'Non-Authoritative Information'; break;
			case 204: $text = 'No Content'; break;
			case 205: $text = 'Reset Content'; break;
			case 206: $text = 'Partial Content'; break;
			case 300: $text = 'Multiple Choices'; break;
			case 301: $text = 'Moved Permanently'; break;
			case 302: $text = 'Moved Temporarily'; break;
			case 303: $text = 'See Other'; break;
			case 304: $text = 'Not Modified'; break;
			case 305: $text = 'Use Proxy'; break;
			case 400: $text = 'Bad Request'; break;
			case 401: $text = 'Unauthorized'; break;
			case 402: $text = 'Payment Required'; break;
			case 403: $text = 'Forbidden'; break;
			case 404: $text = 'Not Found'; break;
			case 405: $text = 'Method Not Allowed'; break;
			case 406: $text = 'Not Acceptable'; break;
			case 407: $text = 'Proxy Authentication Required'; break;
			case 408: $text = 'Request Time-out'; break;
			case 409: $text = 'Conflict'; break;
			case 410: $text = 'Gone'; break;
			case 411: $text = 'Length Required'; break;
			case 412: $text = 'Precondition Failed'; break;
			case 413: $text = 'Request Entity Too Large'; break;
			case 414: $text = 'Request-URI Too Large'; break;
			case 415: $text = 'Unsupported Media Type'; break;
			case 500: $text = 'Internal Server Error'; break;
			case 501: $text = 'Not Implemented'; break;
			case 502: $text = 'Bad Gateway'; break;
			case 503: $text = 'Service Unavailable'; break;
			case 504: $text = 'Gateway Time-out'; break;
			case 505: $text = 'HTTP Version not supported'; break;
			default:
			exit('Unknown http status code "' . htmlentities($code) . '"');
			break;
			}

			$protocol = (isset($_SERVER['SERVER_PROTOCOL']) ? $_SERVER['SERVER_PROTOCOL'] : 'HTTP/1.0');

			header($protocol . ' ' . $code . ' ' . $text);

			$GLOBALS['http_response_code'] = $code;

		} else {

			$code = (isset($GLOBALS['http_response_code']) ? $GLOBALS['http_response_code'] : 200);

		}

		return $code;

	}
}
