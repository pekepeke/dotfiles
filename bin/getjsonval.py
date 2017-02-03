#!/usr/bin/env python2

import sys, os.path, json

if len(sys.argv) < 2:
    sys.stderr.write("invalid argument: %s\n" % sys.argv)
    exit(1)
if not os.path.exists(sys.argv[1]):
    sys.stderr.write("invalid argument: %s\n" % (sys.argv[1]))
    exit(1)

fp = open(sys.argv[1])
data = json.load(fp)

for i in range(2, len(sys.argv)):
    k = sys.argv[i]
    if k in data:
        data = data[k]
        if not isinstance(data, list) or not isinstance(data, dict) or not isinstance(data, tuple) :
            print(data)
            exit(0)

