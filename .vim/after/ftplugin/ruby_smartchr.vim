let s:save_cpo = &cpo
set cpo&vim

inoremap <expr> <buffer> { smartchr#loop('{', '#{', '{{{')
inoremap <buffer><expr> > smartchr#one_of('>', '=>', '>>')

let &cpo = s:save_cpo
