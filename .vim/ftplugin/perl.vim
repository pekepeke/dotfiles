"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:loaded_perl_ftplugin')
  let g:loaded_perl_ftplugin = 1

  let g:perl_include_pod = 1
  let g:perl_extended_vars = 1
  let g:perl_want_scope_in_variabled = 1
  "let g:perl_fold = 1
  "let g:perl_fold_blocks = 1
endif

setl expandtab

let &cpo = s:save_cpo
