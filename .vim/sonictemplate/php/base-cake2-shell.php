<?php
App::uses('AppShell', 'Console');

class {{_name_}} extends AppShell {
	public $tasks = array();
	public $uses = array();

	public function getOptionParser() {
		$parser = parent::getOptionParser();
		// $parser->addOption("param", array(
		// 	"help" => "desc",
		// ));
		return $parser;
	}

	public function main() {
		// $this->TaskName->execute();
		{{_cursor_}}
	}

}
