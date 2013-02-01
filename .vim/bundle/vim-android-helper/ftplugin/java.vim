"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" load once {{{
" if exists('g:loaded_java_ftplugin') | finish | endif
" let g:loaded_java_ftplugin = 1
"
" if exists('b:did_ftplugin') | finish | endif
" let b:did_ftplugin = 1
" }}}

if android_helper#is_saved_classpath()
  call android_helper#save_classpath()
endif

call android_helper#add_android_classpath()

" load once in buffer {{{
" if exists('b:did_after_java_ftplugin') | finish | endif
" let b:did_java_ftplugin = 1
" }}}

let &cpo = s:save_cpo
