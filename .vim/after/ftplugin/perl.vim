let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=ro
setl complete=.,w,b,t,k,kspell

let g:perl_include_pod = 1
let g:perl_extended_vars = 1
let g:perl_want_scope_in_variabled = 1
let g:perl_fold = 1

nmap <buffer> epd i<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
vmap <buffer> epd yi<CR>use Data::Dumper;<CR>warn Dumper <ESC>pa;<CR><ESC>
nmap <silent> <buffer> em :PerlUseInsertionCWord<CR>

" nnoremap <buffer> <silent> <C-K> :Ref perldoc<CR>


let &cpo = s:save_cpo
