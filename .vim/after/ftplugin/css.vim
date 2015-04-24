scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


setlocal dictionary=~/.vim/dict/css.dict
setlocal iskeyword+=- iskeyword-=:

let &cpo = s:save_cpo

