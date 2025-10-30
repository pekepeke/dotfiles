function FindProxyForURL(url, host) {
	var DEFAULT = 'DIRECT';
	var PROXY = 'PROXY 127.0.0.1:8087';

	var SCHEME = url.substring(0, url.indexOf(":"));

	if (SCHEME == "https" || SCHEME == "ftp") {
		return DEFAULT;
	}
	// @see examples http://findproxyforurl.com/example-pac-file/
	// if (isInNet(host, "202.232.xxx.0","255.255.255.0")) {
	// 	return DEFAULT;
	// }
	// if (shExpMatch(url,"*catv.ne.jp*")) {
	// 	return DEFAULT;
	// }
	// if (shExpMatch(host,"*202.232.xxx.*")) {
	// 	return DEFAULT;
	// }
	// if (isInNet(dnsResolve(host), "192.168.0.0", "255.255.255.0")) {
	// 	return DEFAULT;
	// }

	// return DEFAULT;
	return PROXY;

} //end FindProxyForURL
// vim:fdm=marker sw=2 ts=2 ft=javascript noexpandtab:
