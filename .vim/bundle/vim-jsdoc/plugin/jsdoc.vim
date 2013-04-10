if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_jsdoc')
  finish
endif
let s:save_cpo = &cpo
set cpo&vim


command! -nargs=0 JsDoc call jsdoc#insert()
nnoremap <silent> <Plug>(jsdoc) :<C-u>call jsdoc#insert()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_jsdoc = 1

" vim: foldmethod=marker
