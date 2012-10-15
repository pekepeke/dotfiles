<?php

function log_write($message, $type = "debug") {
	static $path = null;
	if (is_null($path)) {
		$path = "/path/to/";
	}
	if (is_array($message) || is_object($message)) {
		$message = var_export($message, true);
	}
	$output = date('Y-m-d H:i:s') . ' ' . ucfirst($type) . ': ' . $message . "\n";
	return file_put_contents($filename, $output, FILE_APPEND);
}

