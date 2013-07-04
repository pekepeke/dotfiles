let s:save_cpo = &cpo
set cpo&vim

inoremap <buffer><expr> . synchat#not_src()?'.':smartchr#one_of('.', '->', '..')

let &cpo = s:save_cpo
