#!/usr/bin/env python
# coding: utf-8

import sys
import subprocess

def main():
    if (len(sys.argv) < 2):
        return 0
    subprocess.call("pyflakes %s" % sys.arg[1])
    subprocess.call("pep8 %s" % sys.argv[1])
    return 0

if __name__ == '__main__':
    main()

