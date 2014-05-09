"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/objc.dict
" setl softtabstop=4 tabstop=4 shiftwidth=4
setl noexpandtab
let g:clang_auto_user_options = 'path, .clang_complete, ios'

let &cpo = s:save_cpo
