if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_<+FILENAME_NOEXT+>')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim


let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_<+FILENAME_NOEXT+> = 1

" vim: foldmethod=marker
