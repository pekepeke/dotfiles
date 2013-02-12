<?php
function sql_log_write($sql, $params = array()) {
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
	$m = array();
	foreach ($params as $k => $v) {
		$m[] = "{$k}={$v}";
	}
	$message = sprintf("%s \n[%s]", $sql, implode(",", $m));
	$output = date('Y-m-d H:i:s') . ' | ' . $message . "\n";
	return file_put_contents($filename, $output, FILE_APPEND);

}
