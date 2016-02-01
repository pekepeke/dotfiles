<?php

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == "https") {
	$_SERVER['HTTPS'] = 'on';
	$_SERVER["SSL_VERSION_INTERFACE"] = "mod_ssl/2.2.3";
	$_SERVER["SSL_VERSION_LIBRARY"] = "OpenSSL/0.9.8e-fips-rhel5";
	$_SERVER["SSL_PROTOCOL"] = "TLSv1";
	$_SERVER["SSL_SECURE_RENEG"] = "true";
	$_SERVER["SSL_COMPRESS_METHOD"] = "NULL";
	$_SERVER["SSL_CIPHER"] = "DHE-RSA-AES256-SHA";
	$_SERVER["SSL_CIPHER_EXPORT"] = "false";
	$_SERVER["SSL_CIPHER_USEKEYSIZE"] = "256";
	$_SERVER["SSL_CIPHER_ALGKEYSIZE"] = "256";
	$_SERVER["SSL_CLIENT_VERIFY"] = "NONE";
	$_SERVER["SSL_SERVER_M_VERSION"] = "3";
	$_SERVER["SSL_SERVER_M_SERIAL"] = "6B5B";
	$_SERVER["SSL_SERVER_V_START"] = "Aug 30 13:53:57 2013 GMT";
	$_SERVER["SSL_SERVER_V_END"] = "Aug 30 13:53:57 2014 GMT";
	$_SERVER["SSL_SERVER_S_DN"] = "/C=–/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain";
	$_SERVER["SSL_SERVER_S_DN_C"] = "–";
	$_SERVER["SSL_SERVER_S_DN_ST"] = "SomeState";
	$_SERVER["SSL_SERVER_S_DN_L"] = "SomeCity";
	$_SERVER["SSL_SERVER_S_DN_O"] = "SomeOrganization";
	$_SERVER["SSL_SERVER_S_DN_OU"] = "SomeOrganizationalUnit";
	$_SERVER["SSL_SERVER_S_DN_CN"] = "localhost.localdomain";
	$_SERVER["SSL_SERVER_S_DN_Email"] = "root@localhost.localdomain";
	$_SERVER["SSL_SERVER_I_DN"] = "/C=–/ST=SomeState/L=SomeCity/O=SomeOrganization/OU=SomeOrganizationalUnit/CN=localhost.localdomain/emailAddress=root@localhost.localdomain";
	$_SERVER["SSL_SERVER_I_DN_C"] = "–";
	$_SERVER["SSL_SERVER_I_DN_ST"] = "SomeState";
	$_SERVER["SSL_SERVER_I_DN_L"] = "SomeCity";
	$_SERVER["SSL_SERVER_I_DN_O"] = "SomeOrganization";
	$_SERVER["SSL_SERVER_I_DN_OU"] = "SomeOrganizationalUnit";
	$_SERVER["SSL_SERVER_I_DN_CN"] = "localhost.localdomain";
	$_SERVER["SSL_SERVER_I_DN_Email"] = "root@localhost.localdomain";
	$_SERVER["SSL_SERVER_A_KEY"] = "rsaEncryption";
	$_SERVER["SSL_SERVER_A_SIG"] = "sha1WithRSAEncryption";
	$_SERVER["SSL_SESSION_ID"] = "BE411F57BA97B3C7D61FC07B0DA965B99BF448081CA8C936C2BDE0C320712F3E";
}

