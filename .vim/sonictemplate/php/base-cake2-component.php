<?php

class {{_name_}} extends Component {

	var $components = array();
	var $settings = array();

	//called before Controller::beforeFilter()
	function initialize(Controller $controller, $settings = array()) {
		parent::initialize($controller, $settings);
		// $this->controller = $controller;
		$this->settings = array_merge($this->settings, $settings);
	}

	//called after Controller::beforeFilter()
	function startup(Controller $controller) {
		parent::startup($controller);
	}

	//called after Controller::beforeRender()
	function beforeRender(Controller $controller) {
		// $this->controller->set(array());
		parent::beforeRender($controller);
	}

	//called after Controller::render()
	function shutdown(Controller $controller) {
		parent::shutdown($controller);
	}

	//called before Controller::redirect()
	function beforeRedirect(Controller $controller, $url, $status=null, $exit=true) {
		parent::beforeRedirect($controller);
	}
}

