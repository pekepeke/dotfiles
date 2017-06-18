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


class RevealResponse:
    def __init__(self, filename, theme):
        self.filename = filename
        self.theme = theme

    def callback(self, query):
        lines = open(self.filename, 'r').read()
        html = """
<!doctype html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>{title}</title>
        <meta name="description" content="%s">

        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

        <link rel="stylesheet" href="{base}/css/reveal.css">
        <link rel="stylesheet" href="{base}/css/theme/{theme}.css" id="theme">

        <!-- For syntax highlighting -->
        <link rel="stylesheet" href="{base}/lib/css/zenburn.css">

        <link rel="stylesheet" href="{menu_base}/menu.css">

        <!-- If the query includes 'print-pdf', include the PDF print sheet -->
        <script>
            if( window.location.search.match( /print-pdf/gi ) ) {
                var link = document.createElement( 'link' );
                link.rel = 'stylesheet';
                link.type = 'text/css';
                link.href = '{base}/css/print/pdf.css';
                document.getElementsByTagName( 'head' )[0].appendChild( link );
            }
        </script>

        <!--[if lt IE 9]>
        <script src="{base}/lib/js/html5shiv.js"></script>
        <![endif]-->
    </head>

    <body>

        <div class="reveal">

            <!-- Any section element inside of this container is displayed as a slide -->
            <div class="slides">
                <section data-markdown
                    data-separator="\r?\n---\r?\n$"
                    data-vertical="\r?\n--\r?\n"
                    data-separator-notes="^Note:"
                    >
                    <script type="text/template">
{markdown}
                    </script>
                </section>
            </div>

        </div>

        <script src="{base}/lib/js/head.min.js"></script>
        <script src="{base}/js/reveal.js"></script>

        <script>

            // Full list of configuration options available here:
            // https://github.com/hakimel/reveal.js#configuration
            Reveal.initialize({
                controls: true,
                slideNumber: true,
                progress: true,
                history: true,
                overview: true,
                center: true,
                touch: true,
                fragments: true,
                transition: 'slide',// none/fade/slide/convex/concave/zoom
                theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
                menu: {
                    markers: true,
                    openSlideNumber: true,
                    themes: [
                        { name: 'Black', theme: 'reveal.js/css/theme/black.css' },
                        { name: 'White', theme: 'reveal.js/css/theme/white.css' },
                        { name: 'League', theme: 'reveal.js/css/theme/league.css' },
                        { name: 'Sky', theme: 'reveal.js/css/theme/sky.css' },
                        { name: 'Beige', theme: 'reveal.js/css/theme/beige.css' },
                        { name: 'Simple', theme: 'reveal.js/css/theme/simple.css' },
                        { name: 'Serif', theme: 'reveal.js/css/theme/serif.css' },
                        { name: 'Blood', theme: 'reveal.js/css/theme/blood.css' },
                        { name: 'Night', theme: 'reveal.js/css/theme/night.css' },
                        { name: 'Moon', theme: 'reveal.js/css/theme/moon.css' },
                        { name: 'Solarized', theme: 'reveal.js/css/theme/solarized.css' }
                ],
                custom: [
                    { title: 'Custom', icon: '<i class="fa fa-bookmark">', src: 'links.html' },
                ]
                },
                // Optional libraries used to extend on reveal.js
                dependencies: [
                    { src: '{base}/lib/js/classList.js', condition: function() { return !document.body.classList; } },
                    { src: '{base}/plugin/markdown/marked.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
                    { src: '{base}/plugin/markdown/markdown.js', condition: function() { return !!document.querySelector( '[data-markdown]' ); } },
                    { src: '{base}/plugin/highlight/highlight.js', async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
                    { src: '{base}/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
                    { src: '{base}/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } },
                    { src: '{menu_base}/menu.js', async: true}
                ]
            });

        </script>

    </body>
</html>
"""
        # return (html.replace("{base}", "https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.5.0")
                    # .replace("{orig_base}", "http://lab.hakim.se/reveal-js/")
                    # .replace("{orig_base}", "http://raw.githubusercontent.com/hakimel/reveal.js/master")
        return (html.replace("{base}", "http://cdn.rawgit.com/hakimel/reveal.js/3.5.0")
                    .replace("{orig_base}", "http://cdn.rawgit.com/hakimel/reveal.js/3.5.0")
                    .replace("{menu_base}", "http://cdn.rawgit.com/denehyg/reveal.js-menu/0.7.3")
                    .replace("{title}",self.filename)
                    .replace("{markdown}","".join(lines))
                    .replace("{theme}",self.theme)
                    .strip().split("\n"))

def start(port, callback):
    def handler(*args):
        CallbackServer(callback, *args)
    server = HTTPServer(('', int(port)), handler)
    server.serve_forever()

if __name__ == '__main__':
    __version__ = "0.0.1"
    p = OptionParser(version="ver:%s" % __version__)
    p.add_option("-t", "--theme", dest="theme",
            default="black", help="theme")
    p.add_option("-p", "--port", dest="port",
            default=8082, help="port")

    opts, args = p.parse_args()

    callback = RevealResponse(args.pop(0), opts.theme)

    start(opts.port, callback)


