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

"setl fdm=syntax
setl formatoptions-=ro
setl complete=.,w,b,t,k,kspell
setl iskeyword-=:
setl expandtab

if exists('*PerlLocalLibPath')
  "y-uuki/perl-local-lib-path.vim"
  PerlLocalLibPath
endif

nmap <buffer> [t]pd i<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
vmap <buffer> [t]pd yi<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
nmap <silent> <buffer> [t]pm :PerlUseInsertionCWord<CR>

nnoremap <buffer> <silent> [comment-doc] :call <SID>my_pod_header()<CR>

inoremap <buffer><expr> @ smartchr#one_of('@', '$this->', '@@')
inoremap <buffer><expr> . smartchr#one_of('.', '->', '..')
inoremap <buffer><expr> > smartchr#one_of('>', '=>', '>>')


let &cpo = s:save_cpo
