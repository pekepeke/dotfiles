#!/usr/bin/env php
<?php

//set_include_path(implode(PATH_SEPARATOR,
//array(
//	get_include_path(),
//	dirname(__FILE__).'/lib',
//)));

class Command {
	var $opts = array();
	var $argv = array();
	var $parseOptions = "huc:t:o:s:d:";
	static $pdo = null;

	var $skipTables = array(
		"sqlite_sequence",
	);

	static function run() {
		$command = new static();
		$ret = $command->exec();
	}

	function exec() {
		$this->optparse();
		$this->init();

		$ret = $this->beforeMain();
		if ($ret != 0) {
			return 255;
		}
		$ret = $this->main();
		$this->afterMain($ret);

		return $ret;
	}

	function optparse() {
		$argv = $GLOBALS['argv'];
		$options = $this->parseOptions;
		$opts = getopt($options);
		foreach( $opts as $o => $a ) {
			while( $k = array_search("-".$o, $argv) ) {
				if ($k) {
					unset($argv[$k]);
				}

				if (strpos($options, $o . ":") !== false) {// preg_match( "/^.*".$o.":.*$/i", $options) ) {
					unset($argv[$k+1]);
				} else {
					$opts[$o] = isset($opts[$o]);	// convert bool vars
				}
			}
		}
		array_shift($argv);				// remove prog name
		$this->argv = array_merge($argv);		// reindex
		$this->opts = $opts;
	}

	function stdin($msg = null, $prompt = "> ") {
		if ($msg) {
			echo "** " . $msg . "\n";
		}
		echo $prompt;
		return chop(fgets(STDIN));
	}

	function yesno($msg = null) {
		$s = $this->stdin($msg, "[y/n] > ");
		$yes_or_no = strtolower($s);
		return ($yes_or_no == "yes" || $yes_or_no == "y");
	}

	function err($msg = null) {
		fputs(STDERR, "[Error] " . $msg . "\n");
		return $this;
	}

	function out($msg = null) {
		echo $msg . "\n";
		return $this;
	}

	function error($msg = null) {
		if ($msg) {
			$this->err($msg);
		}
		$this->afterMain(1);
		exit(1);
	}

	function beforeMain() {
		return 0;
	}

	function afterMain($ret) {}

	function init() {
		if (isset($this->opts["h"])) {
			$this->usage();
			exit(1);
		} else {
			$this->opts["u"] = isset($this->opts["u"]);
			!isset($this->opts["o"]) && $this->opts["o"] = "texts.sqlite";

			!isset($this->opts["t"]) && $this->opts["t"] = array();
			$t = $this->opts["t"];
			if (is_string($t)) {
				$this->opts["t"] = array($t);
			}
			!isset($this->opts["c"]) && $this->opts["c"] = array();
			$c = $this->opts["c"];
			if (is_string($c)) {
				$this->opts["c"] = array($c);
			}

			!isset($this->opts["d"]) && $this->opts["d"] = ".";
			!isset($this->opts["s"]) && $this->opts["s"] = array();
			$c = $this->opts["s"];
			if (is_string($c)) {
				$this->opts["s"] = array($c);
			}
		}
	}

	function usage() {
		$prog = basename(__FILE__);
		echo implode("\n", array(
			"Usage : $prog [options] [csv or tsv file path]",
			"",
			"  -h          : Show This message",
			"  -u          : With utf-8 encoding",
			"  -t [tsv]    : Input TSV filepath",
			"  -c [csv]    : Input CSV filepath",
			"  -s [sqlite] : Input sqlite3 filepath",
			"  -d [dir]    : Output sqlite32csv directory(default .)",
			"  -o [db]     : Output sqlite3 database path(default texts.sqlite)",
		)) . "\n";
	}

	function main() {
		$this->databasePath = $this->opts["o"];

		foreach ($this->opts["t"] as $fpath) {
			$this->process($fpath, $this->createTsvReader($fpath));
		}
		foreach ($this->opts["c"] as $fpath) {
			$this->process($fpath, $this->createCsvReader($fpath));
		}
		foreach ($this->opts["s"] as $fpath) {
			$this->sqlite2csv($fpath);
		}

		foreach ($this->argv as $fpath) {
			$ext = pathinfo($fpath, PATHINFO_EXTENSION);
			$reader = null;
			switch(strtolower($ext)) {
			case 'csv':
				$reader = $this->createCsvReader($fpath);
				$this->process($fpath, $reader);
				break;
			case 'tsv':
				$reader = $this->createTsvReader($fpath);
				$this->process($fpath, $reader);
				break;
			case 'db':
			case 'sqlite':
			case 'sqlite3':
				$this->sqlite2csv($fpath);
				break;
			default:
				fputs(STDERR, "Unknown file format : $ext\n");
				break;
			}
		}
	}

	function sqlite2csv($fpath) {
		$org_pdo = self::$pdo;
		$pdo = $this->_connect($fpath);
		self::$pdo = $pdo;

		$tables = $this->tableList();
		foreach ($tables as $table) {
			if (in_array($table, $this->skipTables)) {
				continue;
			}
			$sql = "select * from $table";
			$pdo = $this->connect();
			$stmt = $pdo->prepare($sql);
			if ($stmt === false) {
				throw new PDOException("error at $sql");
			}
			$stmt->execute();
			$headers = null;

			$cw = new CSVWriter();
			while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
				if (!$headers) {
					$headers = array_keys($row);
					$cw->addLine($headers);
				}
				$cw->addLine($row);
			}
			$stmt->closeCursor();
			if (!$cw->isEmpty()) {
				file_put_contents( $this->opts["d"] . DIRECTORY_SEPARATOR . "$table.csv", $cw->render());
			}
		}

		self::$pdo = $org_pdo;
		unset($pdo);
	}

	function connect($is_new = false) {
		if (!file_exists($this->databasePath)) {
			// init
			$sql3 = new SQLite3($this->databasePath, SQLITE3_OPEN_READWRITE | SQLITE3_OPEN_CREATE);
			$sql3->close();
		}
		if ($is_new) {
			return $this->_connect();
		}
		if (is_null(self::$pdo)) {
			self::$pdo = $this->_connect();
		}
		return self::$pdo;
	}

	function _connect($fpath = null) {
		is_null($fpath) && $fpath = $this->databasePath;
		$pdo = new PDO("sqlite:{$fpath}", "", "", array(
			PDO::ERRMODE_EXCEPTION => true,
		));
		return $pdo;
	}

	function begin() {
		$pdo = $this->connect();
		return $pdo->beginTransaction();
	}

	function commit() {
		return $this->connect()->commit();
	}

	function rollback() {
		return $this->connect()->commit();
	}

	function executeSQL($sql, $params = array()) {
		$pdo = $this->connect();
		$stmt = $pdo->prepare($sql);
		if ($stmt === false) {
			throw new PDOException("error at $sql");
		}
		$ret = $stmt->execute($params);
		$stmt->closeCursor();
		return $ret;
	}

	function findFirst($sql, $params = array()) {
		$pdo = $this->connect();
		$stmt = $pdo->prepare($sql);
		if ($stmt === false) {
			throw new PDOException("error at $sql");
		}
		$stmt->execute($params);
		$ret = $stmt->fetch(PDO::FETCH_ASSOC);
		$stmt->closeCursor();
		return $ret;
	}

	function findAll($sql, $params = array()) {
		$pdo = $this->connect();
		$stmt = $pdo->prepare($sql);
		if ($stmt === false) {
			throw new PDOException("error at $sql");
		}
		$stmt->execute($params);
		$ret = $stmt->fetchAll(PDO::FETCH_ASSOC);
		$stmt->closeCursor();
		return $ret;
	}

	function tableList() {
		$pdo = $this->connect();
		$rows = $this->findAll("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name");
		$list = array();
		foreach ($rows as $row) {
			$list[] = $row["name"];
		}
		return $list;
	}

	function process($fpath, $csv) {

		$basenames = explode(".", basename($fpath));
		$table = $basenames[0];
		$lines = $csv->readAll();
		$fields = array_shift($lines);
		$types = array_fill(0, count($fields), 'int');
		foreach ($lines as $line) {
			foreach ($types as $i => $type) {
				if ($type == "string") {
					continue;
				}
				if (!is_numeric($line[$i])) {
					$types[$i] = "string";
				} elseif (strpos($line[$i], ".") !== false) {
					$types[$i] = "real";
				}
			}
		}
		// for multibyte fields
		foreach ($fields as $i => $v) {
			$fields[$i] = sprintf("[%s]", $v);
		}
		$table = sprintf("[%s]", $table);

		$s = array();
		foreach ($fields as $i => $field) {
			$s[] = "$field {$types[$i]}";
		}
		try {
			$ddl = sprintf("CREATE TABLE %s (%s)", $table, implode(", ", $s));

			$this->executeSQL($ddl);
		} catch(PDOException $e) {
			fputs(STDERR, $e->getMessage() . "\n");
			// return false;
		}

		try {
			$this->begin();
			$field_s = implode(", ", $fields);
			$val_s = implode(", ", array_fill(0, count($fields), '?'));

			$count = 0;
			foreach ($lines as $line) {
				$dml = sprintf("INSERT INTO %s (%s) VALUES (%s)", $table, $field_s, $val_s);
				$this->executeSQL($dml, $line);
				$count++;
			}
			$this->commit();
			fputs(STDOUT, "imported $table : $count\n");
		} catch(PDOException $e) {
			$this->rollback();
			fputs(STDERR, $e->getMessage() . "\n");

			// $ddl = sprintf("DROP TABLE %s", $table);
			// $this->executeSQL($ddl);
			return false;
		}
		return true;
	}

	function createTsvReader($fpath) {
		$tsv = new CSVReader($fpath);
		$tsv->delimiter = "\t";
		// $tsv->enclosure = '"';
		if ($this->opts["u"]) {
			$tsv->encoding = "utf8";
		}
		return $tsv;
	}

	function createCsvReader($fpath) {
		$csv = new CSVReader($fpath);

		if ($this->opts["u"]) {
			$csv->encoding = "utf8";
		}
		return $csv;
	}
}

class CSVReader {
	/**
	 * delimiter
	 *
	 * @var string
	 * @access public
	 */
	public $delimiter = ",";
	/**
	 * enclosure
	 *
	 * @var string
	 * @access public
	 */
	public $enclosure = '"';
	/**
	 * path
	 *
	 * @var string
	 * @access protected
	 */
	protected $path = null;
	/**
	 * encoding
	 *
	 * @var string
	 * @access protected
	 */
	// protected $encoding = "cp932";
	protected $encoding = null;
	/**
	 * to_encoding
	 *
	 * @var string
	 * @access protected
	 */
	protected $to_encoding = null;
	/**
	 * fp
	 *
	 * @var file
	 * @access protected
	 */
	protected $fp = null;
	/**
	 * eof
	 *
	 * @var bool
	 * @access protected
	 */
	protected $eof = false;
	/* protected __construct($path = null) {{{ */
	/**
	 * constructor
	 *
	 * @param string $path
	 * @access protected
	 * @return void
	 */
	function __construct($path = null) {
		$this->path = $path;
		$this->to_encoding = mb_internal_encoding();
	}
	// }}}

	/* public toEncoding($to_encoding) {{{ */
	/**
	 * 変換先エンコーディングを設定します。
	 *
	 * @param string $to_encoding
	 * @access public
	 * @return $this
	 */
	function toEncoding($to_encoding) {
		$this->to_encoding = $to_encoding;
		return $this;
	}
	// }}}

	/* public path($path) {{{ */
	/**
	 * CSV パスを設定します。
	 *
	 * @param string $path
	 * @access public
	 * @return $this
	 */
	function path($path) {
		$this->path = $path;
		$this->fp = null;
		$this->eof = false;
		return $this;
	}
	// }}}

	/* public encoding($encoding) {{{ */
	/**
	 * 変換元エンコーディングを設定します。
	 *
	 * @param string $encoding
	 * @access public
	 * @return $this
	 */
	function encoding($encoding) {
		$this->encoding = $encoding;
		return $this;
	}
	// }}}

	/* public readAll() {{{ */
	/**
	 * ファイル内容全てを読み込んだ結果を返却します。
	 *
	 * @access public
	 * @return array
	 */
	function readAll() {
		$lines = array();
		while (($line = $this->read()) !== false) {
			$lines[] = $line;
		}
		return $lines;
	}
	// }}}

	/* public read() {{{ */
	/**
	 * 一行読み込んだ結果を返却します。
	 *
	 * @access public
	 * @return array|false
	 */
	function read() {
		if (!isset($this->fp)) {
			$src = preg_replace('/\r\n|\r|\n/', "\n", file_get_contents($this->path));
			if (!$this->encoding) {
				$this->encoding = mb_detect_encoding($src, "JIS, sjis-win,eucjp-win, utf8");
			}
			$src = mb_convert_encoding($src, $this->to_encoding, $this->encoding);
			$fp = fopen('php://temp/maxmemory:'. (5*1024*1024), 'r+');
			fwrite($fp, $src);
			rewind($fp);
			$this->fp = $fp;
		}
		$fp = $this->fp;
		$line = $this->fgetcsv_reg($fp, null, $this->delimiter, $this->enclosure);
		return $line;
	}
	// }}}

	/* public isEof() {{{ */
	/**
	 * EOF かどうか判定した結果を返却します。
	 *
	 * @access public
	 * @return void
	 */
	function isEof() {
		if (isset($this->fp)) {
			return feof($this->fp);
		}
		return false;
	}
	// }}}

	/* public fgetcsv_reg(&$handle, $length = null, $d = ',', $e = '"') {{{ */
	/**
	 * csv のパースを実施します。
	 *
	 * @param resource $handle
	 * @param integer $length
	 * @param string $d
	 * @param string $e
	 * @access public
	 * @return array
	 */
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
	// }}}
}

class CSVWriter {
	public $path;
	/**
	 * delimiter
	 *
	 * @var string
	 * @access public
	 */
	public $delimiter = ",";
	/**
	 * enclosure
	 *
	 * @var string
	 * @access public
	 */
	public $enclosure = '"';
	/**
	 * nullString
	 *
	 * @var string
	 * @access public
	 */
	public $nullString = null;

	/**
	 * レコード保持用バッファ
	 *
	 * @var array
	 * @access protected
	 */
	protected $line = null;
	/**
	 * CSV 一時書き込みリソース
	 *
	 * @var resource
	 * @access protected
	 */
	protected $buffer = null;
	/**
	 * encoding
	 *
	 * @var string
	 * @access protected
	 */
	protected $encoding = "cp932";
	/**
	 * from_encoding
	 *
	 * @var string
	 * @access protected
	 */
	protected $from_encoding = null;
	/* protected __construct() {{{ */
	/**
	 * constructor
	 *
	 * @access protected
	 * @return void
	 */
	function __construct() {
		$this->from_encoding = mb_internal_encoding();
		$this->clear();
	}
	// }}}

	/* public fromEncoding($from_encoding) {{{ */
	/**
	 * fromEncoding
	 *
	 * @param string $from_encoding
	 * @access public
	 * @return $this
	 */
	function fromEncoding($from_encoding) {
		$this->from_encoding = $from_encoding;
		return $this;
	}
	// }}}
	/* public encoding($encoding) {{{ */
	/**
	 * encoding
	 *
	 * @param string $encoding
	 * @access public
	 * @return $this
	 */
	function encoding($encoding) {
		$this->encoding = $encoding;
		return $this;
	}
	// }}}

	/* public clear() {{{ */
	/**
	 * clear
	 *
	 * @access public
	 * @return $this
	 */
	function clear() {
		$this->records = array();
		$this->line = array();
		$this->buffer = fopen('php://temp/maxmemory:'. (5*1024*1024), 'r+');
		return $this;
	}
	// }}}
	/* public add($item) {{{ */
	/**
	 * add
	 *
	 * @param mixed $item
	 * @access public
	 * @return $this
	 */
	function add($item) {
		$this->line[] = $item;
		return $this;
	}
	// }}}

	function addEmpty($count = 1) {
		for ($i = 0; $i < $count; $i++) {
			$this->add("");
		}
		return $this;
	}

	/* public next() {{{ */
	/**
	 * next
	 *
	 * @access public
	 * @return $this
	 */
	function next() {
		$this->fputcsv_reg($this->buffer, $this->line, $this->delimiter, $this->enclosure, $this->nullString);
		$this->line = array();
		return $this;
	}
	// }}}

	/* public addLine($items) {{{ */
	/**
	 * CSV 行データをセットします。
	 *
	 * @param array|string $items
	 * @access public
	 * @return $this
	 */
	function addLine($items) {
		if (!is_array($items)) {
			$items = func_get_args();
		}
		$this->line = array_merge($this->line, $items);
		return $this->next();
	}
	// }}}

	/* public grid($grid) {{{ */
	/**
	 * csv データを一括セットします。
	 *
	 * @param mixed $grid
	 * @access public
	 * @return $this
	 */
	function grid($grid) {
		foreach ($grid as $line) {
			$this->addLine($line);
		}
		return $this;
	}
	// }}}

	/* public render() {{{ */
	/**
	 * CSVを返却します。
	 *
	 * @access public
	 * @return $this
	 */
	function render() {
		rewind($this->buffer);
        $s = stream_get_contents($this->buffer);
        if ($this->encoding) {
        	$s = mb_convert_encoding($s, $this->encoding, $this->from_encoding);
        }
        return $s;
	}
	// }}}

	/* public response($filename, $contents = null) {{{ */
	/**
	 * CSV レスポンスを返却します。
	 *
	 * @param string $filename
	 * @param string $contents
	 * @param boolean $exit
	 * @access public
	 * @return void
	 */
	function response($filename, $contents = null, $exit = false) {
		if (!isset($contents)) {
			$contents = $this->render();
		}
		$filename = $this->normalizeFilename($filename);
		if ($this->isMSIE()) {
			$filename = mb_convert_encoding($filename, "SJIS-win", $this->from_encoding);
		}
		header("Content-type:application/vnd.ms-excel");
		header("Content-disposition:attachment; filename=\"{$filename}\"");
		echo $contents;
		if ($exit) {
			exit(0);
		}
	}
    // }}}

	/**
	 * CSVから1行読み込みます。
	 *
	 * @param resource $fh
	 * @param array $fields
	 * @param string $delimiter
	 * @param string $enclosure
	 * @param string $null_string
	 * @access public
	 * @return void
	 */
	function fputcsv_reg($fh, array $fields, $delimiter = ',', $enclosure = '"', $null_string = false) {
		$delimiter_esc = preg_quote($delimiter, '/');
		$enclosure_esc = preg_quote($enclosure, '/');

		$output = array();
		foreach ($fields as $field) {
			if ($field === null && $null_string) {
				$output[] = $null_string;
				continue;
			}

			$output[] = preg_match("/(?:${delimiter_esc}|${enclosure_esc}|\s)/", $field) ? (
				$enclosure . str_replace($enclosure, $enclosure . $enclosure, $field) . $enclosure
			) : $field;
		}

		fwrite($fh, implode($delimiter, $output) . "\r\n");
	}

	function isMSIE() {
		$ua = $_SERVER['HTTP_USER_AGENT'];
		return preg_match('/msie/i', $ua) > 0;
	}

	function normalizeFilename($filename) {
		return str_replace(array(
			":", ";", "/", "\\", "|", ",", "*", "?", "\"", "<", ">", "~"
			), array(
			"：", "；", "／", "￥", "｜", "、", "＊", "？", "”", "＜", "＞", "〜"
			), $filename);
	}
	function isEmpty() {
		if ($this->buffer) {
			$stat = ftell($this->buffer);
			return $stat <= 0;
		}
		return true;
	}
}


Command::run();
if (basename(__FILE__) == basename($_SERVER['PHP_SELF'])) {
}
