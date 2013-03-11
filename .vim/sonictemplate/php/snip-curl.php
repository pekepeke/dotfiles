
class CurlClient {

	var $useragent = 'TestUI';
	var $timeout = 30;
	var $connecttimeout = 30;
	var $ssl_verifypeer = FALSE;
	var $http_info;
	var $http_code;
	var $url;
	var $curl_error;
	var $curl_errno;

	function __construct() {
	}

	/**
	 * GET method wrapper
	 *
	 * @param string $url
	 * @param array $parameters
	 * @access public
	 * @return string
	 */
	function get($url, $parameters = array()) {
		$response = $this->doRequest($url, 'GET', $parameters);
		return $response;
	}

	/**
	 * POST method wrapper
	 *
	 * @param string $url
	 * @param array $parameters
	 * @access public
	 * @return string
	 */
	function post($url, $parameters = array()) {
		$response = $this->doRequest($url, 'POST', $parameters);
		return $response;
	}

	/**
	 * DELETE method wrapper
	 *
	 * @param string $url
	 * @param array $parameters
	 * @access public
	 * @return string
	 */
	function delete($url, $parameters = array()) {
		$response = $this->doRequest($url, 'DELETE', $parameters);
		return $response;
	}

	/**
	 * request wrapper
	 *
	 * @param string $url
	 * @param string $method
	 * @param mixed $parameters
	 * @access public
	 * @return string
	 */
	function doRequest($url, $method, $parameters) {
		$data = $this->http_build_query_rfc_3986($parameters);
		switch ($method) {
		case 'GET':
			if ($data) {
				$url .= (strpos($url, "?") === false ? "?" : "&") . $data;
			}
			return $this->http($url, 'GET', null);
		default:
			return $this->http($url, $method, $data);
		}
	}

	/**
	 * http build query rfc3986
	 *
	 * @param array $query_data
	 * @param string $arg_separator
	 * @access public
	 * @return string
	 */
	function http_build_query_rfc_3986($query_data, $arg_separator = '&') {
		$r = '';
		$query_data = (array) $query_data;
		if(!empty($query_data)) {
			foreach($query_data as $k=>$query_var) {
				$r .= $arg_separator;
				$r .= $k;
				$r .= '=';
				$r .= rawurlencode($query_var);
			}
		}
		return trim($r,$arg_separator);
	}

	/**
	 * Make an HTTP request
	 *
	 * @param string $url
	 * @param string $method
	 * @param mixed $postfields
	 * @param string $headers
	 * @access public
	 * @return string
	 */
	function http($url, $method, $postfields = NULL, $headers = array('Expect:')) {
		$this->http_info = array();
		$ci = curl_init();
		/* Curl settings */
		curl_setopt($ci, CURLOPT_USERAGENT, $this->useragent);
		curl_setopt($ci, CURLOPT_CONNECTTIMEOUT, $this->connecttimeout);
		curl_setopt($ci, CURLOPT_TIMEOUT, $this->timeout);
		curl_setopt($ci, CURLOPT_RETURNTRANSFER, TRUE);
		curl_setopt($ci, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ci, CURLOPT_SSL_VERIFYPEER, $this->ssl_verifypeer);
		curl_setopt($ci, CURLOPT_HEADERFUNCTION, array($this, 'getHeader'));
		curl_setopt($ci, CURLOPT_HEADER, FALSE);

		switch ($method) {
		case 'POST':
			curl_setopt($ci, CURLOPT_POST, TRUE);
			if (!empty($postfields)) {
				curl_setopt($ci, CURLOPT_POSTFIELDS, $postfields);
			}
			break;
		case 'DELETE':
			curl_setopt($ci, CURLOPT_CUSTOMREQUEST, 'DELETE');
			if (!empty($postfields)) {
				$url = "{$url}?{$postfields}";
			}
		}

		curl_setopt($ci, CURLOPT_URL, $url);
		$response = curl_exec($ci);
		$this->http_code = curl_getinfo($ci, CURLINFO_HTTP_CODE);
		$this->http_info = array_merge($this->http_info, curl_getinfo($ci));
		$this->url = $url;
		if ($response === false) {
			$this->curl_error = curl_error($ci);
			$this->curl_errno = curl_errno($ci);
		}
		curl_close ($ci);
		return $response;
	}

	/**
	 * Get the header info to store.
	 *
	 * @param string $ch
	 * @param string $header
	 * @access public
	 * @return void
	 */
	function getHeader($ch, $header) {
		$i = strpos($header, ':');
		if (!empty($i)) {
			$key = str_replace('-', '_', strtolower(substr($header, 0, $i)));
			$value = trim(substr($header, $i + 2));
			$this->http_header[$key] = $value;
		}
		return strlen($header);
	}
}


