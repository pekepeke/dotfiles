"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal dictionary=~/.vim/dict/ruby.dict
setlocal tabstop=2 shiftwidth=2 textwidth=0
setlocal cinwords=if,elsif,else,unless,for,while,begin,rescue,def,class,module,require_relative

let &cpo = s:save_cpo
