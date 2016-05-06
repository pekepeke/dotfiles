function log_write($message, $type = "debug") {
	static $filename = null;
	if (is_null($filename)) {
		$filename = "/path/to/file.log";

		// log shift
		if (filesize($filename) > 1024 * 1024) {
			rename($filename, $filename . ".1");
		} elseif (file_exists($filename)) {
			@chmod($filename, 0777);
		}
	}
	if (is_array($message) || is_object($message)) {
		$message = var_export($message, true);
	}
	$output = date('Y-m-d H:i:s') . ' ' . ucfirst($type) . ': ' . $message . "\n";
	return file_put_contents($filename, $output, FILE_APPEND);
}

