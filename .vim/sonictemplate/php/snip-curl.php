class CurlClient
{

    public $clientType = "html";
    public $useragent = 'TestUI';
    public $timeout = 30;
    public $connecttimeout = 30;
    public $sslVerifypeer = false;
    public $httpInfo;
    public $httpCode;
    public $url;
    public $curlError;
    public $curlErrno;
    public $httpHeader;
    public $defaultOptions = array();
    public $defaultHeaders = array(
    );

    function __construct()
    {
        $this->defaultOptions = array(
            CURLOPT_USERAGENT => $this->useragent,
            CURLOPT_CONNECTTIMEOUT => $this->connecttimeout,
            CURLOPT_TIMEOUT => $this->timeout,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => $this->sslVerifypeer,
            CURLOPT_HEADERFUNCTION => array($this, 'getHeader'),
            CURLOPT_HEADER => false,
        );
    }

    /**
     * GET method wrapper
     *
     * @param string $url
     * @param array $parameters
     * @access public
     * @return string
     */
    function get($url, $parameters = array())
    {
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
    function post($url, $parameters = array())
    {
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
    function delete($url, $parameters = array())
    {
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
    function doRequest($url, $method, $parameters)
    {
        switch ($method) {
            case 'GET':
                $data = $this->httpBuildQueryRfc3986($parameters);
                if ($data) {
                    $url .= (strpos($url, "?") === false ? "?" : "&") . $data;
                }
                return $this->http($url, 'GET', null);
            default:
                return $this->http($url, $method, $parameters);
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
    function httpBuildQueryRfc3986($query_data, $arg_separator = '&') {
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
    function http($url, $method, $postfields = NULL, $headers = array()) {
        $this->httpHeader = array();
        $this->httpInfo = array();

        $ch = curl_init();
        // Curl settings
        curl_setopt_array($ch, $this->defaultOptions);

        if ($this->clientType == "json") {
            $postfields = json_encode($postfields);
            $headers[] = 'Content-Type: application/json';
        } else {
            $postfields = $this->httpBuildQueryRfc3986($postfields);
            $headers[] = 'Content-Type: application/x-www-form-urlencoded';
        }

        curl_setopt(CURLOPT_HTTPHEADER, array_merge($this->defaultHeaders, $headers));

        switch ($method) {
            case 'POST':
                curl_setopt($ch, CURLOPT_POST, true);
                if (!empty($postfields)) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, $postfields);
                }
                break;
            case 'PUT':
            case 'DELETE':
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
                curl_setopt($ch, CURLOPT_POST, true);
                if (!empty($postfields)) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, $postfields);
                }
                // if (!empty($postfields)) {
                //     $url = "{$url}?{$postfields}";
                // }
                break;
        }

        curl_setopt($ch, CURLOPT_URL, $url);
        $response = curl_exec($ch);
        $this->httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $this->httpInfo = curl_getinfo($ch);
        $this->url = $url;
        if ($response === false) {
            $this->curlError = curl_error($ch);
            $this->curlErrno = curl_errno($ch);
        }
        curl_close ($ch);
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
            $this->httpHeader[$key] = $value;
        }
        return strlen($header);
    }
}


