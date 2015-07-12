#!/usr/bin/env python
#
# csvdiff.py: compare columns in csv files
#
# Bart Kastermans, www.bartk.nl
#
# use: script file1 file2
#
# then prints all columns in either file not appearing in the other
# file.

import csv
import sys
from optparse import OptionParser
import os

class excel_mac(csv.Dialect):
    delimiter = ','
    quotechar = '"'
    doublequote = True
    skipinitialspace = False
    lineterminator = '\r'
    quoting = csv.QUOTE_MINIMAL
csv.register_dialect("excel_mac", excel_mac)

class excel_unix(csv.Dialect):
    delimiter = ','
    quotechar = '"'
    doublequote = True
    skipinitialspace = False
    lineterminator = '\n'
    quoting = csv.QUOTE_MINIMAL
csv.register_dialect("excel_unix", excel_unix)

# get filenames from command line
parser = OptionParser ()

(options, args) = parser.parse_args ()

if len (args) != 2:
    print "use: script file1 file2"
    sys.exit ()

FILE1 = args [0]
FILE2 = args [1]

# check the files exist
if not os.path.exists (FILE1):
    print FILE1 + " does not exist."

if not os.path.exists (FILE2):
    print FILE2 + " does not exist."

# define functions to use on the data
def get_data (filename):
    """ read csv file into a list of lists """
    fileinfo = []
    csvr = csv.reader (open (filename, "rU"))
    for line in csvr:
        fileinfo.append (line)
    return fileinfo
    # for dialect in ["excel", "excel_unix", "excel_mac"]:
    #     try:
        # except:
        #     print "fail read : dialect = " + dialect
        #     #traceback.print_exc()


def check_data (data):
    """ check that data represents a nonempty square matrix """
    if len (data) == 0: # nonempty
        return False
    
    llen = len (data [0])  # length all rows should have
    for line in data:
        if llen != len (line):
            return False

    return True

def transpose (data):
    """ interchange rows and columns in data.

    We presume the data is nonempty and square for this.
    """
    rowlength = len (data [0])
    transp = map (lambda x: [], range (0, rowlength))
    for row in data:
        for i in range (0, rowlength):
            transp [i].append (row [i])
    return transp

# get the data from the files
data1 = get_data (FILE1)
data2 = get_data (FILE2)

# check both are square
if (not check_data (data1)) or (not check_data (data2)):
    print "ERROR: a matrix not square"
    sys.exit ()

# transpose both
trans1 = transpose (data1)
trans2 = transpose (data2)

# check for different columns
print "in " + FILE1 + ", but not in " + FILE2
for i in range (0, len (trans1)):
    if not trans1 [i] in trans2:
        print trans1 [i]

print "in " + FILE2 + ", but not in " + FILE1
for i in range (0, len (trans2)):
    if not trans2 [i] in trans1:
        print trans2 [i]
