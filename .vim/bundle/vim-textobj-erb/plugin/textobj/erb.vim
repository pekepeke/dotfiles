if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_erb')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

call textobj#user#plugin('erb', {
\   'tag': {
\       '*pattern*': ['<%\(=\|-\|\s*#\)\?[[:blank:][:return:]\n]*','[[:blank:][:return:]\n]*%>'],
\       'select-a': 'a5',
\       'select-i': 'i5',
\   },
\})

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_erb = 1

" vim: foldmethod=marker
