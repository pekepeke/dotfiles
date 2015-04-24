"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal dictionary=~/.vim/dict/javascript.dict
setlocal dictionary+=~/.vim/dict/qunit.dict
setlocal dictionary+=~/.vim/dict/wsh.dict
setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab
setlocal suffixesadd=.coffee,.js,.jade,.json,.cson
" setlocal syntax=jQuery
let b:javascript_lib_use_jquery     = 1
let b:javascript_lib_use_underscore = 1
let b:javascript_lib_use_backbone   = 0
let b:javascript_lib_use_prelude    = 0
let b:javascript_lib_use_angularjs  = 1

let &cpo = s:save_cpo
