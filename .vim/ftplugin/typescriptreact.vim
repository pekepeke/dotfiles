"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal cinwords=if,else,for,while,do,try,except,finally,function,switch,case

let &cpo = s:save_cpo
