# Usage: mitmdump -s "inject_weinre.py"

# (this script works best with --anticache)
import re, socket, sys
try:
    import httplib
except:
    import http.client as httplib
try:
    import netlib.http as http
except:
    try:
        import libmproxy.protocol.http as http
    except:
        import mitmproxy.http as http

# from libmproxy.protocol.http import decoded

ips = [ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")][:1]

enabled = False
try:
    conn = httplib.HTTPConnection("localhost:58080")
    conn.request("HEAD", "/")
    res = conn.getresponse()
    enabled = True
    if res.status >= 400:
        enabled = False
except:
    pass

def start(context, argv):
    if len(ips):
        context.ip = ips[-1]
    else:
        enabled = False
        # raise ValueError("ip addr not found")

    # if len(argv) != 3:
    #     raise ValueError('Usage: -s "modify-response-body.py old new"')
    # # You may want to use Python's argparse for more sophisticated argument parsing.
    # context.old, context.new = argv[1], argv[2]


def response(context, flow):
    headers = flow.response.headers
    is_text = None
    if hasattr(headers, "get_first"):
        is_text = headers.get_first('content-type', "").startswith("text")
    else:
        is_text = len(headers.get_all("content-type")) > 0

    if enabled:
        if is_text:
            with http.decoded(flow.response):  # automatically decode gzipped responses.
                # flow.response.content = flow.response.content.replace(context.old, context.new)
                flow.response.content = re.sub(r'(?i)(</body[^>]*>)', '<script src="http://%s:58080/target/target-script-min.js#anonymous"></script>\\1' % context.ip, flow.response.content)
        # sys.stderr.write(flow.response.headers.get_first('content-type', ""))
