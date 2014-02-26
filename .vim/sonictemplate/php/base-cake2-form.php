<?php
App::uses('AppModel', 'Model');

class {{_name_}} extends AppModel {
	public $useTable = false;
	public $validate = array(
		"field" => array(
			"numeric" => array(
				"rule" => array("numeric"),
			),
		)
	);
}


