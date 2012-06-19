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
