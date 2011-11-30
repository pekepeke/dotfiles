compiler coffee

if exists('g:loaded_coffee_flyquickfixmake_ftplugin') | finish | endif
let g:coffee_make_options="-o ".$HOME."/.tmp/coffee"
let s:save_cpo = &cpo
set cpo&vim


if !executable('coffee')
  " echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.coffee,Cakefile silent make!
endif


let &cpo = s:save_cpo
let g:loaded_coffee_flyquickfixmake_ftplugin=1

