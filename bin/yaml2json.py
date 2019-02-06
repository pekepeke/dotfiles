#!/usr/bin/env python3

import yaml, json, sys

args = sys.argv[1:]
if len(args) <= 0:
    args = [sys.stdin]
for fname in args:
    if fname == sys.stdin:
        fp = fname
    else:
        fp = open(fname)
    sys.stdout.write(json.dump(yaml.load(fp)))
    if fname != sys.stdin:
        fp.close()
