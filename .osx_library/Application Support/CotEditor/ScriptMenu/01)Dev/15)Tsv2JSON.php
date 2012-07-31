#!/usr/bin/php
<?php
// %%%{CotEditorXInput=Selection}%%%
// %%%{CotEditorXOutput=ReplaceSelection}%%%

date_default_timezone_set('Asia/Tokyo');
// setlocale(LC_ALL, 'ja_JP');
mb_language('japanese');
mb_internal_encoding('utf-8');
if (function_exists('ini_set')) {
	ini_set('default_charset', 'UTF-8');

	ini_set('magic_quotes_gpc', false);
	ini_set('magic_quotes_runtime', false);
	ini_set('magic_quotes_sybase', false);
	//ini_set('display_errors', 0);
	// ini_set('auto_detect_line_endings', true);
}

class TSV {

	function parse($src) {
		$lines = array();
		$fp = fopen("php://memory", 'rw');
		// $src = mb_convert_encoding(file_get_contents("test.csv"), mb_internal_encoding(), "cp932");
		fwrite($fp, preg_replace('!\\r\\n|\\r|\\n!', "\n", $src));
		rewind($fp);
		if ($fp) {
			$header = $this->fgetcsv_reg($fp, null, "\t");
			while (($items = $this->fgetcsv_reg($fp, null, "\t")) !== false) {
				$hash = array_combine($header, $items);
				$lines[] = $hash;
			}
		}
		return $lines;
	}
	function fgetcsv_reg(&$handle, $length = null, $d = ',', $e = '"') {
		$eof = false;
		$d = preg_quote($d);
		$e = preg_quote($e);
		$_line = "";
		while ($eof != true) {
			$_line .= (empty($length) ? fgets($handle) : fgets($handle, $length));
			$itemcnt = preg_match_all('/'.$e.'/', $_line, $dummy);
			if ($itemcnt % 2 == 0) $eof = true;
		}
		$_csv_line = preg_replace('/(?:\\r\\n|[\\r\\n])?$/', $d, trim($_line));
		$_csv_pattern = '/('.$e.'[^'.$e.']*(?:'.$e.$e.'[^'.$e.']*)*'.$e.'|[^'.$d.']*)'.$d.'/';
		preg_match_all($_csv_pattern, $_csv_line, $_csv_matches);
		$_csv_data = $_csv_matches[1];
		for($_csv_i=0;$_csv_i<count($_csv_data);$_csv_i++){
			$_csv_data[$_csv_i]=preg_replace('/^'.$e.'(.*)'.$e.'$/s','$1',$_csv_data[$_csv_i]);
			$_csv_data[$_csv_i]=str_replace($e.$e, $e, $_csv_data[$_csv_i]);
		}
		return empty($_line) ? false : $_csv_data;
	}

}

$stdin = file_get_contents("php://stdin");
$tsv = new TSV;
$stdout = json_encode($tsv->parse($stdin));//'/*' . $stdin . '*/';
echo $stdout;


