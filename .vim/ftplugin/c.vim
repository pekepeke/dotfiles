"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal path+=.,/usr/include,/usr/local/include
let g:clang_auto_user_options = 'path, .clang_complete'

let &cpo = s:save_cpo
