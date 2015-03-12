if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_unite_projectionist')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! ProjectionistJsonEdit call unite_projectionist#edit()

let g:loaded_unite_projectionist = 1
" vim: foldmethod=marker
let &cpo = s:save_cpo
unlet s:save_cpo

