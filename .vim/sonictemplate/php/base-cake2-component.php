<?php

class {{_name_}}Component extends Component {

	var $components = array();
	var $settings = array();

	//called before Controller::beforeFilter()
	function initialize($controller, $settings = array()) {
		// saving the controller reference for later use
		// $this->controller =& $controller;
		$this->settings = array_merge($this->settings, $settings);
	}

	//called after Controller::beforeFilter()
	function startup($controller) {
	}

	//called after Controller::beforeRender()
	function beforeRender($controller) {
		// $this->controller->set(array());
	}

	//called after Controller::render()
	function shutdown($controller) {
	}

	//called before Controller::redirect()
	function beforeRedirect($controller, $url, $status=null, $exit=true) {
	}
}

