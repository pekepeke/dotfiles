if exists('g:loaded_<+FILENAME_NOEXT+>_ftplugin') | finish | endif

let s:save_cpo = &cpo
set cpo&vim


setl shellpipe=2>&1\ \|\ tee
if !executable('<%= substitute(expand('%:t:r'), '_.\+$', '', 'e') %>')
  " echoerr "can't execute flyquickfixmake"
else
  au BufWritePost *.<%= substitute(expand('%:t:r'), '_.\+$', '', 'e') %> silent make!
endif


let &cpo = s:save_cpo

let g:loaded_<+FILENAME_NOEXT+>_ftplugin = 1
