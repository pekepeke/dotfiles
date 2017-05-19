
class CurlException extends RuntimeException
{
}

class CurlResponse
{
    public $url;
    public $code;
    public $body;
    public $info;
    public $errorNo;
    public $errorMessage;

    public static function make()
    {
        return new static();
    }

    public function __construct()
    {
    }

    public function setUrl($url)
    {
        $this->url = $url;
        return $this;
    }
    public function setCode($code)
    {
        $this->code = $code;
        return $this;
    }

    public function setBody($body)
    {
        $this->body = $body;
        return $this;
    }

    public function setInfo($info)
    {
        $this->info = $info;
        return $this;
    }

    public function setError($errno, $message)
    {
        $this->errorNo = $errno;
        $this->errorMessage = $message;
        return $this;
    }

    public function raise()
    {
        if ($this->errorNo !== 0 && $this->errorNo !== null) {
            throw new CurlException($this->errorMessage, $this->errorNo);
        }
        if ($this->code < 200 || $this->code >= 400) {
            throw new CurlException("Unexpected http code - " . $this->code, $this->code);
        }
        return $this;
    }
}

class CurlClient
{
    public $clientType = "html";
    public $userAgent = 'DevBot/1.0'; // "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML,  like Gecko) Chrome/28.0.1500.63 Safari/537.36"
    public $timeout = 30;
    public $connectTimeout = 30;
    public $sslVerifypeer = false;
    public $raiseException = false;

    public $httpHeader;
    public $defaultOptions = array();
    public $defaultHeaders = array();

    public $useCookie = false;
    public $cookieName;

    public function __construct()
    {
        $this->defaultOptions = array(
            CURLOPT_USERAGENT => $this->userAgent,
            CURLOPT_CONNECTTIMEOUT => $this->connectTimeout,
            CURLOPT_TIMEOUT => $this->timeout,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => $this->sslVerifypeer,
            CURLOPT_HEADERFUNCTION => array($this, 'storeHeader'),
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
    public function get($url, $parameters = array(), $headers = array())
    {
        return $this->request($url, strtoupper(__FUNCTION__), $parameters, $headers);
    }

    /**
     * POST method wrapper
     *
     * @param string $url
     * @param array $parameters
     * @access public
     * @return string
     */
    public function post($url, $parameters = array(), $headers = array())
    {
        return $this->request($url, strtoupper(__FUNCTION__), $parameters, $headers);
    }

    /**
     * DELETE method wrapper
     *
     * @param string $url
     * @param array $parameters
     * @access public
     * @return string
     */
    public function delete($url, $parameters = array(), $headers = array())
    {
        return $this->request($url, strtoupper(__FUNCTION__), $parameters, $headers);
    }

    /**
     * PUT method wrapper
     *
     * @param mixed $url
     * @param array $parameters
     * @return string
     */
    public function put($url, $parameters = array(), $headers = array())
    {
        return $this->request($url, strtoupper(__FUNCTION__), $parameters, $headers);
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
    public function request($url, $method, $parameters, $headers = array())
    {
        switch ($method) {
            case 'GET':
                $data = $this->httpBuildQueryRfc3986($parameters);
                if ($data) {
                    $url .= (strpos($url, "?") === false ? "?" : "&") . $data;
                }
                return $this->execute($url, 'GET', null, $headers);
            default:
                return $this->execute($url, $method, $parameters, $headers);
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
    protected function httpBuildQueryRfc3986($data, $sep = '&')
    {
        $r = '';
        $data = (array) $data;
        if (!empty($data)) {
            foreach ($data as $k => $val) {
                $r .= $sep;
                $r .= $k;
                $r .= '=';
                $r .= rawurlencode($val);
            }
        }
        return trim($r, $sep);
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
    protected function execute($url, $method, $postfields = null, $headers = array())
    {
        $this->httpHeader = array();

        $ch = curl_init();
        // Curl settings
        curl_setopt_array($ch, $this->defaultOptions);

        if ($this->clientType == "json") {
            $postfields = json_encode($postfields);
            $headers[] = 'Content-Type: application/json';
            $headers[] = 'Accept: application/json';
        } else {
            $postfields = $this->httpBuildQueryRfc3986($postfields);
            $headers[] = 'Content-Type: application/x-www-form-urlencoded';
        }

        curl_setopt($ch, CURLOPT_HTTPHEADER, array_merge($this->defaultHeaders, $headers));

        if ($this->useCookie) {
            curl_setopt($ch, CURLOPT_COOKIEJAR, $this->cookieName);
            curl_setopt($ch, CURLOPT_COOKIEFILE, $this->cookieName);
        }

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
        $body = curl_exec($ch);
        $info = curl_getinfo($ch);

        $response = CurlResponse::make()
            ->setUrl($url)
            ->setCode($info["http_code"])
            ->setBody($body)
            ->setInfo($info);
        // $this->httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

        if ($body === false) {
            $response->setError(curl_errno($ch), curl_error($ch));
        }
        curl_close($ch);

        if ($this->raiseException) {
            $response->raise();
        }
        if ($this->clientType == "json") {
            $json = json_decode($body, true);
            if ($json !== null || $json !== false) {
                $response->setBody($json);
            }
        }

        return $response;
    }

    public function setDefaultCurlOptions($options = array())
    {
        $this->defaultOptions = array_merge($this->defaultOptions, $options);
        return $this;
    }

    public function useCookie($filename = null)
    {
        is_null($filename) && $filename = __DIR__ . DIRECTORY_SEPARATOR . 'cookie.txt';
        $this->useCookie = true;
        $this->cookieName = $filename;
        return $this;
    }

    public function disableCookie()
    {
        $this->useCookie = false;
        return $this;
    }

    /**
     * Get the header info to store.
     *
     * @param string $ch
     * @param string $header
     * @access public
     * @return void
     */
    protected function storeHeader($ch, $header)
    {
        $i = strpos($header, ':');
        if (!empty($i)) {
            $key = str_replace('-', '_', strtolower(substr($header, 0, $i)));
            $value = trim(substr($header, $i + 2));
            $this->httpHeader[$key] = $value;
        }
        return strlen($header);
    }
}
