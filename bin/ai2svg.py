#!/usr/bin/python
import sys
import os
import re
import getopt
import string


(options, files) = getopt.getopt (sys.argv[1:],
				  "h", ["--help"])


def help():
	print '''ai2svg.py -- simple minded Adobe Illustrator to SVG convertor

Usage:

  ai2svg.py FILE.ai
	
Options

  -h,--help     this screen

Description

 Converts AI to SVG. This is a very rudimentary convertor. It was
 cleanly written, so it is easily extendable. Please mail patches to
 hanwen@xs4all.nl

'''

for (o, a) in options:
	if o == '-h' or o == '--help':
		help()


def cmyk_to_css (c, m, y, k):
	r = int (max (1 - (k + c), 0))
	g = int (max (1 - (k + m), 0))
	b = int (max (1 - (k + y), 0) )
	return "#%02x%02x%02x" %  (255 * r, 255 * g, 255 * b)

def init_ai_state ():
	return {
		'fill_color': '',
		'stroke_color': '',
		'path': '',
		'cpx': 0,
		'cpy': 0,
		'output' :  '',
		}


def process_move (state, match):
	(x,y) = (match.group (1), match.group (2))
	x = string.atof (x)
	y = string.atof (y)
	state['path'] += ' M %f,%f' %  (x,y)

	state['cpx'] = x
	state['cpy'] = y


def process_lineto (state, match):
	(x,y) = (match.group (1), match.group (2))
	x = string.atof (x)
	y = string.atof (y)
	state['path'] += ' L %f,%f' %  (x,y)

	state['cpx'] = x
	state['cpy'] = y


def process_curveto (state, match):
	cs = []
	for gr in match.groups ():
		cs.append (string.atof (gr))
	
	
	p = 'C %f,%f %f,%f %f,%f '  % tuple (cs)
	state['path'] += p

	x = cs[-2]
	y = cs[-1]

	state['cpx'] = x
	state['cpy'] = y


def process_end_path (state, match):
	close = ''
	stroke = ''
	fill = ''

	key = match.group (1)
	if key == 'S' or key == 'B':
		stroke = 'stroke:%(stroke_color)s' % state
	elif key == 's' or key == 'b':
		stroke = 'stroke:%(stroke_color)s' % state
		close = 1

	if key == 'F' or key == 'B':
		fill = 'fill:%(fill_color)s' % state
	elif key == 'f' or key == 'b':
		fill = 'fill:%(fill_color)s' % state
		close = 1

	if close:
		state['path'] += ' z '

	p = '''
<g style="%s;%s">
	<path d="%s"/>\n
	</g>\n''' % (fill, stroke, state['path'])
	state['output'] += p
	state['path'] = ''

	
def process_gray_color (state, match):
	key = 'fill_color'
	if match.group (2) == 'G':
		key = 'stroke_color'

	state[key] = cmyk_to_css (0,0,0, 1 - string.atof (match.group (1)))

def process_cmyk_color (state, match):
	key = 'fill_color'
	if match.group (2) == 'K':
		key = 'stroke_color'

	css_color = apply (cmyk_to_css, tuple (map (string.atof, match.groups()[:4])))
	state[key] = css_color

dispatch_table = {
	r'^ *([-\d\.]+) +([-\d\.]+) m$': process_move,
	r'^ *([-\d\.]+) +([-\d\.]+) l$': process_lineto,
	r'^ *([-\d\.]+) +([-\d\.]+) +([-\d\.]+) +([-\d\.]+) +([-\d\.]+) +([-\d\.]+) c$': process_curveto,
	r'^ *([-\d\.]+) +([-\d\.]+) +([-\d\.]+) +([-\d\.]+) +([kK])$':
	  process_cmyk_color,
	r'^ *([\d\.]+) +([gG])$': process_gray_color,
	r'^ *([nNBbfFsS]+)': process_end_path,
}
	
dispatch_list  = [(re.compile (k), v) for (k,v) in dispatch_table.items()]

def process_line (state, l):
	found = 0
	for (regex, proc) in dispatch_list:
		m = regex.match (l)
		if m <> None:
			found = 1
			proc (state, m)
			break
		
	if not found:
		print  'ignoring ', l


def dump_output (state, base):
	outf = open (base + '.svg', 'w')
	outf.write (''' <svg xmlns="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink">''')
	outf.write (state['output'])
	outf.write ('</svg>')
	

for f in files:
	base = os.path.basename (f)
	base = os.path.splitext (base)[0]
	
	inf = open (sys.argv[1])
	ai_state = init_ai_state ()
	l = inf.readline()
	while not re.match ("%%EndSetup", l):
		l = inf.readline()
	
	for l in inf.readlines ():
		l = l [:-1]
		process_line (ai_state, l)


	dump_output (ai_state, base)
