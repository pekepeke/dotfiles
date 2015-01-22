"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
setlocal commentstring=<!--%s-->

let &cpo = s:save_cpo
