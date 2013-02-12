function params($s) {
	$args = is_array($s) ? $s : func_get_args();
	if (count($args) <= 1) {
		return isset($_REQUEST[$s]) ? $_REQUEST[$s] : null;
	}
	$params = array();
	foreach ($args as $s) {
		$params[] = isset($_REQUEST[$s]) ? $_REQUEST[$s] : null;
	}
	return $params;
}

