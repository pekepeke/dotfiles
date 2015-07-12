#!/usr/bin/env python
# coding: utf-8

import os, subprocess, sys, time

def main():
    if len(sys.argv) < 3:
        print "Usage: stakeout.py  [files to watch]+"
        sys.exit(1)

    command = sys.argv[1]
    files = {}

    for arg in sys.argv[2:]:
        if os.path.isfile(arg):
            files[arg] = os.path.getmtime(arg)
    last_changed = max(files.values())

    try:
        while True:

            time.sleep(1)

            for file in files.iterkeys():
                file_mtime = os.path.getmtime(file)
                if file_mtime > last_changed:
                    files[file] = last_changed = file_mtime

                    print "=> %s changed, running %s" % (file, command)
                    try:
                        retcode = subprocess.call(command, shell=True)
                        print "=> done"
                    except OSError, e:
                        print >>sys.stderr, "Execution failed:", e
    except KeyboardInterrupt:
        pass
    return 0

if __name__ == '__main__':
    main()

