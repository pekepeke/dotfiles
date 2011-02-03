" Vim compiler file
" Compiler:	Microsoft MSBuild
" Maintainer:	palm3r (http://d.hatena.ne.jp/palm3r/)
" Last Change:	2008 Sep 14

if exists("current_compiler")
  finish
endif
let current_compiler = "msbuild"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

" default errorformat
CompilerSet errorformat=
  \%E%f(%l\\,%c):\ error\ %m,
  \%W%f(%l\\,%c):\ warning\ %m,
  \%-G%.%#

" default make
CompilerSet makeprg=MSBuild
  \\ /nologo
  \\ /consoleloggerparameters:
    \NoItemAndPropertyList;
    \ForceNoAlign; 

