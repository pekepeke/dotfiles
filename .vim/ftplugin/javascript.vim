"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/javascript.dict
setl dictionary+=~/.vim/dict/qunit.dict
setl dictionary+=~/.vim/dict/wsh.dict
setl tabstop=2 shiftwidth=2 textwidth=0 expandtab
" setl syntax=jQuery
let b:javascript_lib_use_jquery     = 1
let b:javascript_lib_use_underscore = 1
let b:javascript_lib_use_backbone   = 0
let b:javascript_lib_use_prelude    = 0
let b:javascript_lib_use_angularjs  = 1

let &cpo = s:save_cpo
