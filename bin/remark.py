#!/usr/bin/env python
# coding: utf-8

import requests
from BaseHTTPServer import HTTPServer
from BaseHTTPServer import BaseHTTPRequestHandler
import urlparse
from optparse import OptionParser

class CallbackServer(BaseHTTPRequestHandler):
    def __init__(self, callback, *args):
        self.callback = callback
        BaseHTTPRequestHandler.__init__(self, *args)

    def do_GET(self):
        parsed_path = urlparse.urlparse(self.path)
        query = parsed_path.query
        self.send_response(200)
        self.end_headers()
        result = self.callback.callback(query)
        message = '\r\n'.join(result)
        self.wfile.write(message)
        return


class RemarkResponse:
    def __init__(self, filename):
        self.filename = filename

    def callback(self, query):
        lines = open(self.filename, 'r').read()
        html = """
<!DOCTYPE html>
<html>
  <head>
    <title>%s</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <style type="text/css">
      @import url(http://fonts.googleapis.com/css?family=Yanone+Kaffeesatz);
      @import url(http://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic);
      @import url(http://fonts.googleapis.com/css?family=Ubuntu+Mono:400,700,400italic);
      body { font-family: 'Droid Serif'; }
      h1, h2, h3 {
        font-family: 'Yanone Kaffeesatz';
        font-weight: normal;
      }
      .remark-code, .remark-inline-code { font-family: 'Ubuntu Mono'; }
    </style>
  </head>
  <body>
    <textarea id="source">
%s
    </textarea>
    <script src="http://gnab.github.io/remark/downloads/remark-latest.min.js" type="text/javascript"></script>
    <script type="text/javascript">
      var slideshow = remark.create();
    </script>
  </body>
</html>
""" % (self.filename, "".join(lines))
        return html.split("\n")

def start(port, callback):
    def handler(*args):
        CallbackServer(callback, *args)
    server = HTTPServer(('', int(port)), handler)
    server.serve_forever()

if __name__ == '__main__':
    __version__ = "0.0.1"
    p = OptionParser(version="ver:%s" % __version__)
    p.add_option("-p", "--port", dest="port",
            default=8082, help="port")

    opts, args = p.parse_args()

    callback = RemarkResponse(args.pop(0))

    start(opts.port, callback)

