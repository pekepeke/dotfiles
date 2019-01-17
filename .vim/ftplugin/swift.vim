"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal expandtab

" load once in buffer {{{
if exists('b:did_after_swift_ftplugin') | finish | endif
let b:did_swift_ftplugin = 1
" }}}

let &cpo = s:save_cpo
