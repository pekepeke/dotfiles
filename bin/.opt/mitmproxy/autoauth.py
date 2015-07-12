import json
import os, io
import base64

class MitmProxyAutoAuthConfig(object):

    __config = {
        "example.com" : {
            "user": "example",
            "password": "password",
        },
    }

    def __init__(self):
        self.last_modified = 0
        self.config = {}
        self.ini_path = os.path.join(os.environ['HOME'], '.mitmproxy', 'conf.d', 'autoauth.json')
        self.load_config()

    def load_config(self):
        if os.path.exists(self.ini_path):
            stat = os.stat(self.ini_path)
            modified = stat.st_mtime
            if modified > self.last_modified:
                json_s = open(self.ini_path, "r").read()
                self.config = json.loads(json_s)
                self.last_modified = modified
                # pickle.dump(replace_hosts, os.sys.stderr)
        else:
            config = self.__config
            if not os.path.isdir(os.path.dirname(self.ini_path)):
                os.mkdir(os.path.dirname(self.ini_path))
            with io.open(self.ini_path, 'w', encoding='utf-8') as f:
                f.write(unicode(json.dumps(config, ensure_ascii=False)))
            self.config = config
        return self.config

def start(context, argv):
    context.config = MitmProxyAutoAuthConfig()

def request(context, flow):
    autoauth_hosts = context.config.load_config()
    if flow.request.host in autoauth_hosts:
        # os.sys.stderr.write("autoauth\n")
        original = str(flow.request.host)
        data = autoauth_hosts[original]
        method = data["method"] if "method" in data else "Basic"
        user = data["user"] if "user" in data else "username"
        password = data["password"] if "password" in data else "password"
        token = ""
        if method == "Basic":
            token = base64.b64encode(user + ":" + password)
        if len(token) > 0:
            flow.request.headers["Authorization"] = ["%s %s" % (method, token)]
