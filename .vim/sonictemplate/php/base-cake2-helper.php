<?php

class {{_name_}} extends AppHelper {
	public $helpers = array();

	public function __construct(View $view, $settings = array()) {
		parent::__construct($view, $settings);
	}

	public function beforeRenderFile($viewFile) {
		parent::beforeRenderFile($viewFile);
	}
	public function afterRenderFile($viewFile) {
		parent::afterRenderFile($viewFile);
	}
	public function beforeRender($viewFile) {
		parent::beforeRender($viewFile);
	}
	public function afterRender($viewFile) {
		parent::afterRender($viewFile);
	}
	public function beforeLayout($layoutFile) {
		parent::beforeLayout($layoutFile);
	}
	public function afterLayout($layoutFile) {
		parent::afterLayout($layoutFile);
	}
}
