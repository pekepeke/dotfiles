setl errorformat=%f:%l:%m
setl makeprg=pyflakes
setl shellpipe=2>&1\ >

if exists('g:loaded_python_flyquickmake')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

if !executable('python') || !executable('pyflakes')
  echohl Error | echomsg "can't execute flyquickfixmake[depend on python, pyflakes]" | echohl None
else
  if !exists("g:python_flyquickfixmake")
    au BufWritePost *.py silent make
  endif
endif

let &cpo = s:save_cpo

let g:loaded_python_flyquickmake = 1
