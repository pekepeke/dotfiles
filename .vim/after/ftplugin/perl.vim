let s:save_cpo = &cpo
set cpo&vim

"setlocal fdm=syntax
setlocal formatoptions-=r formatoptions-=o
setlocal complete=.,w,b,t,k,kspell
setlocal iskeyword-=:
setlocal softtabstop=0 tabstop=4 shiftwidth=4
" setlocal expandtab

if exists('*PerlLocalLibPath')
  "y-uuki/perl-local-lib-path.vim"
  PerlLocalLibPath
endif

nmap <buffer> [t]pd i<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
vmap <buffer> [t]pd yi<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
nmap <silent> <buffer> [t]pm :PerlUseInsertionCWord<CR>

nnoremap <buffer> <silent> [!comment-doc] :call <SID>my_pod_header()<CR>

let &cpo = s:save_cpo
