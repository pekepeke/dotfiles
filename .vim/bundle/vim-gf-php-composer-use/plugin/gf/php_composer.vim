if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_gf_php_composer_use')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

call gf#user#extend('gf#php_composer#find', 2000)

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_gf_php_composer_use = 1

" vim: foldmethod=marker
