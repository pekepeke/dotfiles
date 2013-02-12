function req_is($type) {
	static $_detectors = array(
		'get' => array('env' => 'REQUEST_METHOD', 'value' => 'GET'),
		'post' => array('env' => 'REQUEST_METHOD', 'value' => 'POST'),
		'put' => array('env' => 'REQUEST_METHOD', 'value' => 'PUT'),
		'delete' => array('env' => 'REQUEST_METHOD', 'value' => 'DELETE'),
		'head' => array('env' => 'REQUEST_METHOD', 'value' => 'HEAD'),
		'options' => array('env' => 'REQUEST_METHOD', 'value' => 'OPTIONS'),
		'ssl' => array('env' => 'HTTPS', 'value' => 1),
		'ajax' => array('env' => 'HTTP_X_REQUESTED_WITH', 'value' => 'XMLHttpRequest'),
		'flash' => array('env' => 'HTTP_USER_AGENT', 'pattern' => '/^(Shockwave|Adobe) Flash/'),
		'mobile' => array('env' => 'HTTP_USER_AGENT', 'options' => array(
			'Android', 'AvantGo', 'BlackBerry', 'DoCoMo', 'Fennec', 'iPod', 'iPhone', 'iPad',
			'J2ME', 'MIDP', 'NetFront', 'Nokia', 'Opera Mini', 'Opera Mobi', 'PalmOS', 'PalmSource',
			'portalmmm', 'Plucker', 'ReqwirelessWeb', 'SonyEricsson', 'Symbian', 'UP\\.Browser',
			'webOS', 'Windows CE', 'Windows Phone OS', 'Xiino'
		))
	);
	$type = strtolower($type);
	if (!isset($_detectors[$type])) {
		return false;
	}

	$detect = $_detectors[$type];
	if (isset($detect['env'])) {
		$env = isset($_SERVER[$detect['env']]) ? $_SERVER[$detect['env']] : null;
		if (isset($detect['value'])) {
			return $env == $detect['value'];
		}
		if (isset($detect['pattern'])) {
			return (bool)preg_match($detect['pattern'], $env);
		}
		if (isset($detect['options'])) {
			$pattern = '/' . implode('|', $detect['options']) . '/i';
			return (bool)preg_match($pattern, $env);
		}
	}
	if (isset($detect['callback']) && is_callable($detect['callback'])) {
		// return call_user_func($detect['callback'], $this);
		return call_user_func($detect['callback'], $detect);
	}
	return false;
}

function section($name = null) {
	static $data = null;
	static $sections = array();

	if (is_null($data)) {
		$data = preg_replace('/\r\n|\r|\n/', "\n", file_get_contents(__FILE__, FALSE, NULL, __COMPILER_HALT_OFFSET__));
		$contents = explode('@@', $data);
		foreach (explode('@@', $data) as $section) {
			$lines = explode("\n", $section);
			$key = array_shift($lines);
			$sections[$key] = implode("\n", $lines);
		}
	}
	if (is_null($name)) {
		return $data;
	}
	return $sections[$name];
}


if (!function_exists('render')) {
	function render_file_or_contents($view_path, $vars) {
		extract($vars);
		ob_start();
		if (file_exists($view_path)) {
			include $view_path;
		} else {
			eval('?>' . section($view_path));
		}
		$content = ob_get_clean();
		return $content;
	}

	function render($view, $vars = array(), $layout = null) {
		$content = render_file_or_contents($view, $vars);
		is_null($layout) && !req_is("ajax") && $layout = "layout";

		echo is_null($layout) ? $content : render_file_or_contents($layout, array_merge(compact('content'), $vars));
	}

}


__halt_compiler();
@@layout
