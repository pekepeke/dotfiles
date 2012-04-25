if (!function_exists('is_not_null')) {
	function is_not_null($v) {
		return !is_null($v);
	}
}
if (!function_exists('is_not_empty')) {
	function is_not_empty($v) {
		return !empty($v);
	}
}
if (!function_exists('array_compact')) {
	function array_compact($array) {
		return array_filter($array,"is_not_empty");
	}
}
if (!function_exists('array_empty')) {
	function array_empty($mixed) {
		if (is_array($mixed)) {
			foreach ($mixed as $value) {
				if (!array_empty($value)) {
					return false;
				}
			}
		} else {
			$mixed = trim($mixed);
			if (!empty($mixed)) {
				return false;
			}
		}
		return true;
	}
}
if (!function_exists('array_zip')) {
	function array_zip() {
		$args = func_get_args();

		$ruby = array_pop($args);
		if (is_array($ruby))
			$args[] = $ruby;

		$counts = array_map('count', $args);
		$count = ($ruby) ? min($counts) : max($counts);
		$zipped = array();

		for ($i = 0; $i < $count; $i++) {
			for ($j = 0; $j < count($args); $j++) {
				$val = (isset($args[$j][$i])) ? $args[$j][$i] : null;
				$zipped[$i][$j] = $val;
			}
		}
		return $zipped;
	}
}
