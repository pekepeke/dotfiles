from optparse import OptionParser

p = OptionParser(version="ver:%s" % __version__)
p.add_option("-f", "--file", dest="filename",
                  help="write report to FILE", metavar="FILE")
p.add_option("-q", "--quiet",
                  action="store_false", dest="verbose", default=True,
                  help="don't print status messages to stdout")

opts, args = p.parse_args()

if opts.quiet:
    # print ""
for f in args:
    # print "file: ", f
