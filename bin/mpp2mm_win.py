#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Create a FreeMind (.mm) mind map from a/an MS Project file.
usage: mpp2mm -i <mppfile> -o <mmfile> -a -c
Options and arguments:
-a         : generate (some) Attributes
-c         : generate icons for completed tasks
-i mppfile : input MS Project mpp or xml file
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
import win32com.client
import xml.etree.ElementTree as ET


class Mpp2Mm:

    def __init__(self):
        self.mmn = [] # create an empty node tree
        self.mmn.append("")
        self.lst_lvl = 0 # last level is 0
        self.do_attr = False # by default don't create Attributes
        self.do_flag = False # by default don't flag completion

    def open(self, infile):
        """ Open the .mpp or .xml file and create a tree """
        if infile.endswith('.xml'):
            self.proj = None
            try:
                self.tree = ET.parse(infile)
                return self.tree
            except Exception, e:
                print "Error opening file",e
                usage()
        else:
            try:
                self.mpp = win32com.client.Dispatch("MSProject.Application")
                self.mpp.Visible = False
                self.mpp.FileOpen(infile)
                self.proj = self.mpp.ActiveProject
                return self.proj
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
        if self.proj is None: # .xml file
            root = self.tree.getroot()
#           process Task elements and fabricate hierarchy based upon OutlineLevel
            for node in root:
                if node.tag ==  "{http://schemas.microsoft.com/project}Name":
                    self.mmn[0] = ET.SubElement(self.mm, "node", text=node.text)
                elif node.tag ==  "{http://schemas.microsoft.com/project}Author":
                    if self.do_attr:
                        self.mmn[0].append(ET.Element("attribute", \
                            NAME="prj-Author", VALUE=node.text))
                elif node.tag ==  "{http://schemas.microsoft.com/project}StartDate":
                    if self.do_attr:
                        self.mmn[0].append(ET.Element("attribute", \
                            NAME="prj-StartDate", VALUE=node.text))
                else:
#                   the guts of it is the Tasks
                    if node.tag ==  "{http://schemas.microsoft.com/project}Tasks":
                        for nod in node:
                            if nod.tag ==  "{http://schemas.microsoft.com/project}Task":
                                if nod.findtext("{http://schemas.microsoft.com/project}UID") <> "0":
#                                   UID, Name, Start, Finish, WBS
                                    lvl = nod.findtext("{http://schemas.microsoft.com/project}OutlineLevel")
                                    txt = nod.findtext("{http://schemas.microsoft.com/project}Name")
                                    lvli = int(lvl)
                                    if lvli > self.lst_lvl:
                                        self.mmn.append("")
                                        self.lst_lvl = lvli
                                    self.mmn[lvli] = ET.SubElement(self.mmn[lvli-1], "node",text=txt)
                                    if self.do_attr:
                                        self.mmn[lvli].append(ET.Element("attribute", NAME="tsk-Duration", \
                                            VALUE=nod.findtext("{http://schemas.microsoft.com/project}Duration")))
                                    if self.do_flag:
                                        txt = nod.findtext("{http://schemas.microsoft.com/project}PercentComplete")
                                        if txt == "100":
                                            self.mmn[lvli].append(ET.Element("icon", BUILTIN="button_ok"))

        else: # .mpp file
            self.mmn[0] = ET.SubElement(self.mm, "node", text=self.proj.Project)
            if self.do_attr:
                self.mmn[0].append(ET.Element("attribute", \
                    NAME="prj-Author", VALUE=self.proj.Author))
                self.mmn[0].append(ET.Element("attribute", \
                    NAME="prj-StartDate", VALUE=str(self.proj.ProjectStart)))
            for task in self.proj.Tasks:
                lvli = task.OutlineLevel
                txt = task.Name
                if lvli > self.lst_lvl:
                    self.mmn.append("")
                    self.lst_lvl = lvli
                self.mmn[lvli] = ET.SubElement(self.mmn[lvli-1], "node",text=txt)
                if self.do_attr:
                    txt = str(task.Duration / 480) + "d" # convert to days
                    self.mmn[lvli].append(ET.Element("attribute", NAME="tsk-Duration", \
                        VALUE=txt))
                if self.do_flag:
                    txt = task.PercentComplete
                    if txt == 100:
                        self.mmn[lvli].append(ET.Element("icon", BUILTIN="button_ok"))
            self.mpp.Quit()

        tree = ET.ElementTree(self.mm)
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
    if not (input.endswith('.xml') or input.endswith('.mpp')):
        print "Input file must end with '.mpp' or '.xml'"
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
