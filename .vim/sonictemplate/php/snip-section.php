
function section($name = null) {
	static $data = null;
	static $sections = array();

	if (is_null($data)) {
		$data = preg_replace('/\r\n|\r|\n/', "\n", file_get_contents(__FILE__, FALSE, NULL, __COMPILER_HALT_OFFSET__));
		$contents = explode('@@', $data);
		foreach (explode('@@', $data) as $section) {
			$lines = explode("\n", $section);
			$key = array_shift($lines);
			$sections[$key] = implode("\n", $lines);
		}
	}
	if (is_null($name)) {
		return $data;
	}
	return $sections[$name];
}

// echo section("start");

__halt_compiler(); // __END__
