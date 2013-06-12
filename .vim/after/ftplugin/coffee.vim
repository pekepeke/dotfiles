scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=r formatoptions-=o
" setl dictionary=~/.vim/dict/coffee.dict
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

inoremap <expr> <buffer> { smartchr#loop('{', '#{', '{{')
inoremap <buffer><expr> > smartchr#one_of('>', '->', '>>')
inoremap <buffer><expr> - smartchr#one_of('-', '->', '--')
inoremap <buffer><expr> \ smartchr#one_of('\', '->', '=>', '\\')

let &cpo = s:save_cpo
