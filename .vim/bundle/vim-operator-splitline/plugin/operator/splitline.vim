if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_operator_splitline')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:operator_splitline_no_default_key_mappings =
      \ get(g:, 'operator_splitline_no_default_key_mappings', 0)

call operator#user#define('splitline', 'operator#splitline#do')

if !g:operator_splitline_no_default_key_mappings
  map <CR> <Plug>(operator-splitline)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_operator_splitline = 1

" vim: foldmethod=marker
