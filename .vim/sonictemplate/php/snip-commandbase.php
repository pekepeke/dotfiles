class CommandBase {
	var $opts = array();
	var $argv = array();
	var $parseOptions = "";

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

	function init() {}

	function beforeMain() {
		return 0;
	}

	function afterMain($ret) {}
	function main() {
		{{_cursor_}}
	}
}
