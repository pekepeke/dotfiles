"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" load once {{{
if exists('g:loaded_<+FILENAME_NOEXT+>_ftplugin') | finish | endif
let g:loaded_<+FILENAME_NOEXT+>_ftplugin = 1

if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1
" }}}

" load once in buffer {{{
if exists('b:did_after_<+FILENAME_NOEXT+>_ftplugin') | finish | endif
let b:did_<+FILENAME_NOEXT+>_ftplugin = 1
" }}}

let &cpo = s:save_cpo
