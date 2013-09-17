"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal sw=2 ts=2 expandtab
setlocal foldmethod=marker
setlocal matchpairs+=<:>
let &cpo = s:save_cpo
