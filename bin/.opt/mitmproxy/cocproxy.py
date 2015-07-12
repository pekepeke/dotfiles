
import libmproxy.protocol.http as http
from libmproxy.protocol.http import HTTPResponse
from netlib.odict import ODictCaseless
import os.path
import os.path as ospath
import mimetypes
import re
# import sys, pickle

def start(context, argv):
    context.cwd = os.getcwd()
    context.re = re.compile(r"(.*/|^)[^/\.]*$")

def request(context, flow):
    # pickle.dump(flow.request.host, sys.stderr)
    # pickle.dump(flow.request.path, sys.stderr)
    # pickle.dump("/".join(flow.request.get_path_components()), sys.stderr)
    # pickle.dump(flow.request.pretty_host(hostheader=True), sys.stderr)
    # sys.stderr.write("-------------\n")
    host = flow.request.pretty_host(hostheader=True)
    filename = "/".join(flow.request.get_path_components())

    files = [
        "%s/%s/%s" % (context.cwd, host, filename),
        "%s/%s/%s" % (context.cwd, host, ospath.basename(filename)),
        "%s/%s" % (context.cwd, filename),
        "%s/%s" % (context.cwd, ospath.basename(filename)),
    ]

    if context.re.match(filename):
        filename = filename + "/" + "index.html" if len(filename) > 0 else "index.html"
        files.extend([
            "%s/%s/%s" % (context.cwd, host, filename),
            "%s/%s/%s" % (context.cwd, host, ospath.basename(filename)),
            "%s/%s" % (context.cwd, filename),
            "%s/%s" % (context.cwd, ospath.basename(filename)),
        ])

    for f in files:
        # sys.stderr.write(f +"\n")
        # if ospath.exists(f):
        if ospath.isfile(f):
            content_type = mimetypes.guess_type(f)[0]
            if not content_type:
                content_type = "text/html"
            print(f)
            body = open(f).read()
            resp = HTTPResponse(
                [1, 1], 200, "OK",
                ODictCaseless([["Content-Type", content_type]]),
                body)
            flow.reply(resp)
            break

