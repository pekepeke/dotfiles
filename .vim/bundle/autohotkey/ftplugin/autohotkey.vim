"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" https://github.com/vim-scripts/ahkcomplete
" load once {{{
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1
" }}}

setl completefunc=autohotkey#complete


let &cpo = s:save_cpo
" __END__ {{{1
