"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/ruby.dict
setl tabstop=2 shiftwidth=2 textwidth=0

let &cpo = s:save_cpo
