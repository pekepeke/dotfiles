import json
import os, io
# import pickle

class MitmProxyReplaceHostConfig(object):
    __config = {
        "example.com": "www.google.co.jp"
    }

    def __init__(self):
        self.last_modified = 0
        self.config = {}
        self.ini_path = os.path.join(os.environ['HOME'], '.mitmproxy', 'conf.d', 'replace_hosts.json')
        self.load_config()

    def load_config(self):
        if os.path.exists(self.ini_path):
            stat = os.stat(self.ini_path)
            modified = stat.st_mtime
            if modified > self.last_modified:
                json_s = open(self.ini_path, "r").read()
                self.config = json.loads(json_s)
                # pickle.dump(config, os.sys.stderr)
                self.last_modified = modified
        else:
            config = self.__config
            if not os.path.isdir(os.path.dirname(self.ini_path)):
                os.mkdir(os.path.dirname(self.ini_path))
            with io.open(self.ini_path, 'w', encoding='utf-8') as f:
                f.write(unicode(json.dumps(config, ensure_ascii=False)))
            self.config = config
        return self.config

def start(context, argv):
    context.config = MitmProxyReplaceHostConfig()

def request(context, flow):
    replace_hosts = context.config.load_config()
    if flow.request.host in replace_hosts:
        # os.sys.stderr.write("replace\n")
        original = str(flow.request.host)
        replace = replace_hosts[original]
        # pickle.dump(replace, os.sys.stderr)
        if original in flow.request.headers["Host"]:
            flow.request.host = replace
            flow.request.headers["Host"] = [replace]
            # os.sys.stderr.write(original + "->" + replace + "\n")
