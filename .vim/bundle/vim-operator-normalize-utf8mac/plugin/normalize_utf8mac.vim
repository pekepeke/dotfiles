if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_normalize_utf8mac')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" defines {{{1
call operator#user#define('normalize_utf8mac', 'operator#normalize_utf8mac#exec')

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_normalize_utf8mac = 1

" vim: foldmethod=marker
" __END__ {{{1
