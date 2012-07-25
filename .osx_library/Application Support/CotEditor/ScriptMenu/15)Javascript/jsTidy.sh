#!/bin/sh
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%
/usr/local/bin/perl -MIO::All -MJavaScript::Swell -e 'print JavaScript::Swell->swell(io->stdin->all)'