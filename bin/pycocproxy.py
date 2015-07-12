#!/usr/bin/env python

__doc__ = """PyCocProxy
"""

__version__ = "0.0.1"

import BaseHTTPServer, select, socket, SocketServer, urlparse
from os import path as ospath
import mimetypes, re

class ProxyHandler (BaseHTTPServer.BaseHTTPRequestHandler):
    __base = BaseHTTPServer.BaseHTTPRequestHandler
    __base_handle = __base.handle

    server_version = "PyCocProxy/" + __version__
    rbufsize = 0                        # self.rfile Be unbuffered

    def handle(self):
        (ip, port) =  self.client_address
        if hasattr(self, 'allowed_clients') and ip not in self.allowed_clients:
            self.raw_requestline = self.rfile.readline()
            if self.parse_request(): self.send_error(403)
        else:
            self.__base_handle()

    def _connect_to(self, netloc, soc):
        i = netloc.find(':')
        if i >= 0:
            host_port = netloc[:i], int(netloc[i+1:])
        else:
            host_port = netloc, 80
        print "\t" "connect to %s:%d" % host_port
        try: soc.connect(host_port)
        except socket.error, arg:
            try: msg = arg[1]
            except: msg = arg
            self.send_error(404, msg)
            return 0
        return 1

    def do_CONNECT(self):
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            if self._connect_to(self.path, soc):
                self.log_request(200)
                self.wfile.write(self.protocol_version +
                                 " 200 Connection established\r\n")
                self.wfile.write("Proxy-agent: %s\r\n" % self.version_string())
                self.wfile.write("\r\n")
                self._read_write(soc, 300)
        finally:
            # print "\t" "bye"
            soc.close()
            self.connection.close()

    def do_GET(self):
        (scm, netloc, path, params, query, fragment) = urlparse.urlparse(
            self.path, 'http')
        if scm != 'http' or fragment or not netloc:
            self.send_error(400, "bad url %s" % self.path)
            return
        soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            mime, data, response_file = None, None, None
            files = [ ospath.join(netloc, path), 
                    ospath.join(path),
                    ospath.basename(path), ]
            if not re.match("\.[^/]+$", path):
                files.append(ospath.join(netloc, path, "index.html"))
                files.append(ospath.join(path, "index.html"))
                files.append(ospath.join(ospath.basename(path), "index.html"))

            for fpath in files:
                if ospath.exists(fpath):
                    mime = mimetypes.guess_type("aaa.html")
                    response_file = fpath
                    fp = open(fpath, "r")
                    data = fp.read()
                    fp.close()
                    break

            if mime is not None and data is not None:
                headers = []
                headers.append(self.protocol + ' 200 OK')
                headers.append('Content-Type: ' + mime[0])
                headers.append('Content-Length: ' + str(len(data)))
                headers.append('Cache-Control: no-cache')
                headers.append('Connection: close')
                self.connection.send("\r\n".join(headers) + "\r\n\r\n")
                self.connection.send(data)
                print "file found : " + response_file
                self.log_request()
            elif self._connect_to(netloc, soc):
                self.log_request()
                soc.send("%s %s %s\r\n" % (
                    self.command,
                    urlparse.urlunparse(('', '', path, params, query, '')),
                    self.request_version))
                self.headers['Connection'] = 'close'
                del self.headers['Proxy-Connection']
                for key_val in self.headers.items():
                    soc.send("%s: %s\r\n" % key_val)
                soc.send("\r\n")
                self._read_write(soc)
        finally:
            # print "\t" "bye"
            soc.close()
            self.connection.close()

    def _read_write(self, soc, max_idling=20):
        iw = [self.connection, soc]
        ow = []
        count = 0
        while 1:
            count += 1
            (ins, _, exs) = select.select(iw, ow, iw, 3)
            if exs: break
            if ins:
                for i in ins:
                    if i is soc:
                        out = self.connection
                    else:
                        out = soc
                    data = i.recv(8192)
                    if data:
                        out.send(data)
                        count = 0
            # else:
            #     print "\t" "idle", count
            if count == max_idling: break

    do_HEAD = do_GET
    do_POST = do_GET
    do_PUT  = do_GET
    do_DELETE=do_GET

class ThreadingHTTPServer (SocketServer.ThreadingMixIn,
                           BaseHTTPServer.HTTPServer): pass

if __name__ == '__main__':
    from sys import argv
    port = 8887
    server_address = ('', port)
    ProxyHandler.protocol = "HTTP/1.0"
    httpd = ThreadingHTTPServer(server_address, ProxyHandler)
    sa = httpd.socket.getsockname()
    print "on ", sa[0], "port", sa[1]
    httpd.serve_forever()


