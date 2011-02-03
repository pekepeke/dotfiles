let s:save_cpo = &cpo
set cpo&vim

inoremap <buffer><expr> . smartchr#one_of('.', '->', '..')

let &cpo = s:save_cpo
