if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}}')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" defines {{{1
call operator#user#define('{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}}', 'operator#{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}}#exec')

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}} = 1

" vim: foldmethod=marker
" __END__ {{{1
