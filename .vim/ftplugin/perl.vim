"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:loaded_perl_ftplugin')
  let g:loaded_perl_ftplugin = 1

  let g:perl_compiler_force_warnings = 0
  let g:perl_extended_vars           = 1
  let g:perl_include_pod             = 1
  let g:perl_moose_stuff             = 1
  let g:perl_no_scope_in_variables   = 1
  let g:perl_no_sync_on_global_var   = 1
  let g:perl_no_sync_on_sub          = 1
  let g:perl_nofold_packages         = 1
  let g:perl_pod_formatting          = 1
  let g:perl_pod_spellcheck_headings = 1
  let g:perl_string_as_statement     = 1
  let g:perl_sync_dist               = 1000
  let g:perl_want_scope_in_variables = 1
  "let g:perl_fold = 1
  "let g:perl_fold_blocks = 1
endif

setl expandtab
setl cindent

let &cpo = s:save_cpo
