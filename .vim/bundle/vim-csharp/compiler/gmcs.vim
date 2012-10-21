
if exists("current_compiler")
  finish
endif
let current_compiler = "gmcs"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat&
CompilerSet errorformat+=%-GCompilation\ failed%#,%E%f(%l\,%c):\ error\ %m,%W%f(%l\,%c):\ warning\ %m

CompilerSet makeprg=gmcs\ -checked\ --parse\ %
