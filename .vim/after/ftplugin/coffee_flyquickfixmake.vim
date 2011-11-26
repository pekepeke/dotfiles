" setl makeprg=coffee\ -l\ %\ $*
" setl errorformat=Error:\ In\ %f,\ Parse\ error\ on\ line\ %l:%m
" setl shellpipe=2>&1\ \|\ tee
compiler coffee

if exists('g:loaded_coffee_flyquickfixmake_ftplugin') | finish | endif
let s:save_cpo = &cpo
set cpo&vim


if !executable('coffee')
  " echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.coffee,Cakefile silent make!
endif


let &cpo = s:save_cpo
let g:loaded_coffee_flyquickfixmake_ftplugin=1

