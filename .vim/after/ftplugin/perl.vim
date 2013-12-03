let s:save_cpo = &cpo
set cpo&vim

"setl fdm=syntax
setl formatoptions-=r formatoptions-=o
setl complete=.,w,b,t,k,kspell
setl iskeyword-=:
" setl expandtab

if exists('*PerlLocalLibPath')
  "y-uuki/perl-local-lib-path.vim"
  PerlLocalLibPath
endif

nmap <buffer> [t]pd i<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
vmap <buffer> [t]pd yi<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
nmap <silent> <buffer> [t]pm :PerlUseInsertionCWord<CR>

nnoremap <buffer> <silent> [!comment-doc] :call <SID>my_pod_header()<CR>

inoremap <buffer><expr> @ synchat#isnt_src()?'@':smartchr#one_of('@', '$self->', '@@')
inoremap <buffer><expr> . synchat#isnt_src()?'.':smartchr#one_of('.', '->', '..')
inoremap <buffer><expr> > synchat#isnt_src()?'>':smartchr#one_of('>', '=>', '>>')


let &cpo = s:save_cpo
