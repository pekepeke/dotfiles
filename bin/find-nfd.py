#!/usr/bin/env python
import os
import argparse
from unicodedata import normalize

def fild_all_files(directory):
    for root, dirs, files in os.walk(directory):
        yield root
        for file in files:
            yield os.path.join(root, file)

def to_nfc(string):
    string = string.decode("utf8")
    string = normalize("NFC", string)
    string = string.encode("utf8")
    return string

def is_nfd(string):
    if to_nfc(string) == string:
        return False
    else:
        return True

def find_nfd_files(directory):
    for file in fild_all_files(directory):
        if is_nfd(file):
            yield file

def main():
    parser = argparse.ArgumentParser(description="Find NFD files")
    parser.add_argument("path", type=str, help="path to find(Default: current working directory)", nargs='?', default=os.getcwd())
    args = parser.parse_args()

    count = 0

    for file in find_nfd_files(args.path):
        print file
        count += 1

    print ""
    print "%u files found" % (count)

if __name__ == "__main__":
    main()
