#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Create a FreeMind (.mm) mind map from a/an MS Project XML file.

usage: mpp2mm -i <mppfile> -o <mmfile> -a -c
Options and arguments:
-a         : generate (some) Attributes
-c         : generate icons for completed tasks
-i mppfile : input MS Project xml file
-o mmfile  : output FreeMind map (name defaults to input filename)

Copyright (c) 2009, AnGus King
This code is licensed under the GPLv2 or later.
(http://www.gnu.org/licenses/)

"""

__author__ = "AnGus King"
__copyright__ = "Copyright (C) 2009, AnGus King"
__license__ = "GPLv2 (http://www.gnu.org/licenses/)"
__version__ = "1.1"

import getopt
import sys
import xml.etree.ElementTree as ET

def debug(*args):
    # print(args)
    return 0

class Mpp2Mm:

    def __init__(self):
        self.mmn = [] # create an empty node tree
        self.mmn.append("")
        self.lst_lvl = 0 # last level is 0
        self.do_attr = False # by default don't create Attributes
        self.do_flag = False # by default don't flag completion

    def open(self, infile):
        """ Open the .xml file and create a tree """
        try:
            self.tree = ET.parse(infile)
            return self.tree
        except Exception, e:
            print "Error opening file",e
            usage()

    def write(self, outfile, attr, flag):
        """ Create the .mm file :-) """
        self.do_attr = attr
#       create the mindmap as version 8.1 or 9.0) if generating
#       attribute tags
        if self.do_attr:
            self.mm = ET.Element("map",version="0.9.0")
        else:
            self.mm = ET.Element("map",version="0.8.1")
        self.do_flag = flag
        root = self.tree.getroot()
#       process Task elements and fabricate hierarchy based upon OutlineLevel
        for node in root:
            if node.tag ==  "{http://schemas.microsoft.com/project}Name":
                debug("Project:" , node.text)
                self.mmn[0] = ET.SubElement(self.mm, "node", text=node.text)
            elif node.tag ==  "{http://schemas.microsoft.com/project}Author":
                debug("Author:" , node.text)
                if self.do_attr:
                    self.mmn[0].append(ET.Element("attribute", \
                        NAME="prj-Author", VALUE=node.text))
            elif node.tag ==  "{http://schemas.microsoft.com/project}StartDate":
                debug("StartDate:" , node.text)
                if self.do_attr:
                    self.mmn[0].append(ET.Element("attribute", \
                         NAME="prj-StartDate", VALUE=node.text))
            else:
#               the guts of it is the Tasks
                if node.tag ==  "{http://schemas.microsoft.com/project}Tasks":
                    for nod in node:
                        if nod.tag ==  "{http://schemas.microsoft.com/project}Task":
                            if nod.findtext("{http://schemas.microsoft.com/project}UID") <> "0":
                                debug("UID:", nod.findtext("{http://schemas.microsoft.com/project}UID"))
                                debug("Name:", nod.findtext("{http://schemas.microsoft.com/project}Name"))
                                debug("Start:", nod.findtext("{http://schemas.microsoft.com/project}Start"))
                                debug("Finish:", nod.findtext("{http://schemas.microsoft.com/project}Finish"))
                                debug("WBS:", nod.findtext("{http://schemas.microsoft.com/project}WBS"))
                                lvl = nod.findtext("{http://schemas.microsoft.com/project}OutlineLevel")
                                txt = nod.findtext("{http://schemas.microsoft.com/project}Name")
                                if txt is None:
                                    continue
                                debug("Level/Task:", lvl + " " + txt)
                                lvli = int(lvl)
                                if lvli > self.lst_lvl:
                                    self.mmn.append("")
                                    self.lst_lvl = lvli
                                self.mmn[lvli] = ET.SubElement(self.mmn[lvli-1], "node",text=txt)
                                if self.do_attr:
                                    self.mmn[lvli].append(ET.Element("attribute", NAME="tsk-Duration", \
                                        VALUE=nod.findtext("{http://schemas.microsoft.com/project}Duration")))
                                    for at in ("Start", "Finish"):
                                        val = nod.findtext("{http://schemas.microsoft.com/project}" + at)
                                        if val is not None:
                                            self.mmn[lvli].append(ET.Element("attribute", NAME="tsk-" + at, \
                                                VALUE=val))
                                if self.do_flag:
                                    txt = nod.findtext("{http://schemas.microsoft.com/project}PercentComplete")
                                    if txt == "100":
                                        self.mmn[lvli].append(ET.Element("icon", BUILTIN="button_ok"))
        tree = ET.ElementTree(self.mm)
        # ET.dump(self.mm)
        tree.write(outfile)
        return

def usage():
    print __doc__
    sys.exit(-1)

def main():
    try:
        opts , args = getopt.getopt(sys.argv[1:], "i:o:hac", \
            ["help", "input=", "output="])
    except getopt.GetoptError, err:
        # print help information and exit:
        print err # will print something like "option -x not recognized"
        usage()
    input = None
    output = None
    attr = False
    complete = False
    for o, a in opts:
        if o == "-a": # wants attributes printed
            attr = True
        elif o == "-c": # wants completion flags
            complete = True
        elif o in ("-h", "--help"):
            usage()
        elif o in ("-i", "--input"):
            input = a
        elif o in ("-o", "--output"):
            output = a
        else:
            assert False, "unhandled option"
    if input == None:
        print "Input file required"
        usage()
    if not input.endswith('.xml'):
        print "Input file must end with '.xml'"
        usage()
    if output == None:
        output = input[:-3] + "mm"
    if not output.endswith('.mm'):
        print "Output file must end with '.mm'"
        usage()
    mpp2mm = Mpp2Mm()
    tree = mpp2mm.open(input)
    mpp2mm.write(output,attr,complete)
    print output + " created."


if __name__ == "__main__":
    main()
