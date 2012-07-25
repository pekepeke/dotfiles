#!/usr/bin/python

# %%%{CotEditorXInput=AllText}%%%

import os

HOME_DIR = os.environ['HOME']
if not HOME_DIR:
    HOME_DIR = '/var/tmp'

output_file = os.path.join(HOME_DIR, 'cot_rest.html')
css_file = os.path.join(HOME_DIR, 'Dropbox', 'basic.css')
extra_settings = None
if os.path.isfile(css_file):
    extra_settings = dict(
            stylesheet_path=css_file,
        )

try:
    import locale
    locale.setlocale(locale.LC_ALL, '')
except:
    pass

from docutils.core import publish_cmdline, default_description

description = ('Generates (X)HTML documents from standalone reStructuredText '
               'sources.  ' + default_description)

res = publish_cmdline(
            writer_name='html',
            description=description,
            settings_overrides=extra_settings
        )

file = open(output_file, 'wr')
file.write(res)
file.close()

import commands

commands.getstatusoutput('open %s' % (output_file, ))